//
//  FormChipValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormChipValidationView<Item>: FormValidationContent where Item: AnyItem {
    
    // MARK: - Initializer
    
    public init(value: Binding<[Item]>, collection: [Item]) {
        self._value = value
        self.collection = collection
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var focused: Bool = false
    @State private var validationResult: FormValidationResult = .valid
    @State private var totalHeight = CGFloat.zero // Use .infinity if used in VStack
    @Binding public var value: [Item]
    
    private var collection: [Item]
    
    // MARK: - Body
    
    public var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return VStack {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(value) { chip in
                        ChipView(appearance: appearance,
                                 systemImage: chip.systemImage,
                                 titleKey: chip.titleKey) {
                            remove(chip.id)
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
                    }
                    if isEnabled {
                        AddChipView(appearance: appearance)
                            .padding(.all, 2.5)
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
                            .onTapGesture(perform: addChip)
                    }
                }
                .padding(5)
                .background(updateCorrectViewHeight($totalHeight)) // JB: This is a hack to update view to get the desired height
            }
        }.frame(maxWidth: .infinity, minHeight: totalHeight, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult), lineWidth: focused ? 2 : 1.5)
                    .background((isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor).cornerRadius(10))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
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
    
    private func addChip() {
        
    }
    
    private func remove(_ id: Item.ID) {
        withAnimation {
            value.removeAll { $0.id == id }
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
    var titleKey: LocalizedStringKey {
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
                        FormChipValidationView(value: $currentValues,
                                               collection: NumberChip.allCases)
                    }.padding(.horizontal, 10)
                }
            }.navigationBarTitle("Demo")
        }
    }
}
#endif

extension FormValidationContent where Value : AnyItem {
    
    /// New boolean form
    public static func chip<Item : AnyItem>(value: Binding<[Item]>, collection: [Item]) -> FormChipValidationView<Item> {
        FormChipValidationView(value: value, collection: collection)
    }
}
