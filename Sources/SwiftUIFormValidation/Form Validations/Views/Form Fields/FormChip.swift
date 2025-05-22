//
//  FormChip.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Flow
import SwiftUI

public struct FormChip<Item>: FormValidationContent where Item: AnySelectableItem {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled)
    private var isEnabled: Bool
    @Environment(\.formValidationResult)
    private var validationResult

    // MARK: - FormValidationContent Properties

    @Binding public var value: [Item]
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    @State private var focused: Bool = false
    @State private var totalHeight = CGFloat.zero // Use .infinity if used in VStack
    @State private var showAddChipCollection: Bool = false

    private var collection: [Item]
    private var pickerTitle: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        HFlow(spacing: 5) {
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
                .animation(appearance.animation, value: value)
            }
            if isEnabled {
                Button {
                    showAddChipCollection.toggle()
                } label: {
                    AddChipView(appearance: appearance)
                }
                .sheet(isPresented: $showAddChipCollection) {
                    FormChipValidationSelectorView(
                        pickerTitle: pickerTitle,
                        collection: collection,
                        selected: $value
                    ).presentationDetents([.medium, .large])
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .padding(appearance.leadingPadding)
        .background(
            RoundedRectangle(cornerRadius: appearance.borderRadius, style: .continuous)
                .stroke(
                    appearance.formValidationBorderColor(
                        focused: focused,
                        validationResult: validationResult
                    ),
                    lineWidth: focused ? appearance.borderWidthActive : appearance.borderWidthInactive
                )
                .background(
                    (
                        isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor
                    )
                    .cornerRadius(appearance.borderRadius)
                )
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        )
        .modifier(FormFieldContentModifier($value, model: model))
    }

    // MARK: - Initializer

    /// A chip container that displays a selected set of items as part of the collection.
    /// - Parameters:
    ///   - value: The set of selected items from the collection
    ///   - header: The name of this form field.
    ///   - collection: The collection of items
    ///   - pickerTitle: The title when picker option is shown
    public init(
        _ value: Binding<[Item]>,
        header: LocalizedStringKey? = nil,
        collection: [Item],
        pickerTitle: LocalizedStringKey
    ) {
        self._value = value
        self.model = .init(header: header)
        self.collection = collection
        self.pickerTitle = pickerTitle
    }

    /// A chip container that displays a selected set of items as part of the collection using an option set.
    /// - Parameters:
    ///   - value: The option set of selected items from the collection
    ///   - header: The name of this form field.
    ///   - collection: An option set collection
    ///   - pickerTitle: The title when picker option is shown
    public init(
        _ value: Binding<Item>,
        header: LocalizedStringKey? = nil,
        collection: [Item],
        pickerTitle: LocalizedStringKey
    ) where Item: AnySelectableItem & OptionSet & CaseIterable, Item == Item.Element, Item.RawValue: FixedWidthInteger {
        self._value = Binding(
            get: { value.wrappedValue.components },
            set: { newValue in value.wrappedValue = Item(newValue) }
        )
        self.model = .init(header: header)
        self.collection = collection
        self.pickerTitle = pickerTitle
    }
}

struct FormChipValidationSelectorView<Item>: View where Item: AnySelectableItem {
    @Environment(\.formAppearance)
    private var appearance
    @Environment(\.dismiss)
    private var dismiss

    var pickerTitle: LocalizedStringKey
    @State var collection: [Item]
    @Binding var selected: [Item]

    var body: some View {
        NavigationView {
            appearance.selectableRow(collection, selected: $selected)
            .navigationTitle(pickerTitle)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
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
enum NumberChip: Int, CaseIterable, AnySelectableItem {
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth

    var id: Int {
        rawValue
    }
    var enabled: Bool {
        true
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
    @State static var currentValues: [NumberChip] = [.first, .third, .fourth, .fifth, .fourth, .third, .second]
    static var previews: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Form Chip Validation View Examples")
                        .font(.system(size: 18, weight: .light))
                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                    VStack(spacing: 8) {
                        FormChip(
                            $currentValues,
                            collection: NumberChip.allCases,
                            pickerTitle: "Test Tite"
                        )
                    }.padding(.horizontal, 10)
                }
            }.navigationTitle("Demo")
        }
    }
}
#endif
