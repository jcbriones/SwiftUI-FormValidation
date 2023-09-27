//
//  FormChipValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

private struct Row<Item>: View where Item: AnyItem {
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    let item: Item
    let isSelected: Bool
    let onTap: (() -> Void)?

    var body: some View {
        HStack {
            if let systemImage = item.systemImage {
                Image(systemName: systemImage)
            } else if let imageUrl = item.imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        EmptyView()
                    } else {
                        ProgressView().controlSize(.mini)
                    }
                }.frame(width: 40, height: 40).clipShape(Circle())
            }
            Text(item.localizedString)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.activeTextColor)
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? appearance.activeBorderColor : appearance.inactiveBorderColor)
        }.onTapGesture {
            onTap?()
        }
    }
}

public struct FormChipValidationView<Item>: FormValidationContent where Item: AnyItem {

    // MARK: - Initializer

    init(value: Binding<[Item]>, collection: [Item], pickerTitle: LocalizedStringKey) {
        self._value = value
        self.collection = collection
        self.pickerTitle = pickerTitle
    }

    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.formValidationResult) private var validationResult
    @State private var focused: Bool = false
    @State private var totalHeight = CGFloat.zero // Use .infinity if used in VStack
    @Binding public var value: [Item]
    @State private var showAddChipCollection: Bool = false

    private var collection: [Item]
    private var pickerTitle: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(value) { chip in
                    ChipView(
                        appearance: appearance,
                        systemImage: chip.systemImage,
                        imageUrl: chip.imageUrl,
                        titleKey: chip.localizedString
                    ) {
                        value.removeAll { $0.id == chip.id }
                    }
                    .disabled(!isEnabled)
                    .padding(5)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }

                        let result = width
                        if chip.id == value.last!.id && !isEnabled {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if chip.id == value.last!.id && !isEnabled {
                            height = 0
                        }
                        return result
                    }
                    .animation(appearance.animation, value: value)
                }
                if isEnabled {
                    Button {
                        showAddChipCollection.toggle()
                    } label: {
                        AddChipView(appearance: appearance)
                    }
                    .padding(.all, 5)
                    .alignmentGuide(.leading) { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }

                        let result = width
                        width = 0
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        height = 0
                        return result
                    }
                    .sheet(isPresented: $showAddChipCollection) {
                        FormChipValidationSelectorView(pickerTitle: pickerTitle, collection: collection, selected: $value)
                            .presentationDetents([.medium, .large])
                    }
                }
            }
            .padding(5)
            .background(updateCorrectViewHeight($totalHeight))
        }
        .frame(maxWidth: .infinity, minHeight: totalHeight, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(
                    appearance.formValidationBorderColor(
                        focused: focused,
                        validationResult: validationResult
                    ),
                    lineWidth: focused ? 2 : 1.5
                )
                .background(
                    (
                        isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor
                    )
                    .cornerRadius(10)
                )
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        )
    }

    // MARK: - Private API

    private func updateCorrectViewHeight(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = max(rect.size.height, 34)
            }
            return .clear
        }
    }
}

struct FormChipValidationSelectorView<Item>: View where Item: AnyItem {
    @Environment(\.dismiss) var dismiss

    var pickerTitle: LocalizedStringKey
    @State var collection: [Item]
    @Binding var selected: [Item]

    var body: some View {
        NavigationView {
            List(collection) { item in
                Row(item: item, isSelected: selected.contains(item)) {
                    if let index = selected.firstIndex(of: item) {
                        selected.remove(at: index)
                    } else {
                        selected.append(item)
                    }
                }
            }
            .navigationTitle(pickerTitle)
            .navigationBarTitleDisplayMode(.inline)
#if os(iOS)
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
#endif
        }
    }
}

#if DEBUG
enum NumberChip: Int, CaseIterable, AnyItem {
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth

    var id: Int {
        rawValue
    }
    var systemImage: String? {
        nil
    }
    var imageUrl: URL? {
        self == .fifth || self == .third ? URL(string: "https://asia.omsystem.com/content/000107507.jpg") : nil
    }
    var localizedString: LocalizedStringKey {
        switch self {
        case .first:
            return "First"
        case .second:
            return "Second"
        case .third:
            return "Third"
        case .fourth:
            return "Fourth"
        case .fifth:
            return "Fifth"
        case .sixth:
            return "Sixth"
        }
    }
}

struct FormChipValidationView_Previews: PreviewProvider {
    @State static var currentValues: [NumberChip] = [.first, .second, .third, .fourth, .fifth, .fourth, .third, .second]
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Form Chip Validation View Examples")
                        .font(.system(size: 18, weight: .light))
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    VStack(spacing: 8) {
                        FormChipValidationView(
                            value: $currentValues,
                            collection: NumberChip.allCases, pickerTitle: "Test Tite"
                        )
                    }.padding(.horizontal, 10)
                }
            }.navigationTitle("Demo")
        }
    }
}
#endif

public extension FormValidationContent {
    /// A chip container that displays a selected set of items as part of the collection.
    /// - Parameters:
    ///   - value: The set of selected items from the collection
    ///   - collection: The collection of items
    ///   - pickerTitle: The title when picker option is shown
    static func chip<Item>(
        value: Binding<[Item]>,
        collection: [Item],
        pickerTitle: LocalizedStringKey
    ) -> FormChipValidationView<Item> where Item: AnyItem, Self == FormChipValidationView<Item> {
        FormChipValidationView(
            value: value,
            collection: collection,
            pickerTitle: pickerTitle
        )
    }

    /// A chip container that displays a selected set of items as part of the collection.
    /// - Parameters:
    ///   - value: The set of selected items from the collection
    ///   - collection: An option set collection
    ///   - pickerTitle: The title when picker option is shown
    static func chip<Item>(
        value: Binding<Item>,
        collection: [Item],
        pickerTitle: LocalizedStringKey
    ) -> FormChipValidationView<Item>
    where Item: AnyItem & OptionSet & CaseIterable, Item == Item.Element, Item.RawValue: FixedWidthInteger,
          Self == FormChipValidationView<Item> {
              FormChipValidationView(
                value: Binding(
                    get: { value.wrappedValue.components },
                    set: { newValue in value.wrappedValue = Item(newValue) }
                ),
                collection: collection,
                pickerTitle: pickerTitle
              )
          }
}
