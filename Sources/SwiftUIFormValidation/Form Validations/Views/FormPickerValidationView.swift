//
//  FormPickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormPickerValidationView<Item>: FormValidationContent where Item: AnyItem {
    
    // MARK: - Initializer
    
    public init(value: Binding<Item?>, placeholder: LocalizedStringKey, collection: [Item]) {
        self._value = value
        self.placeholder = placeholder
        self.collection = collection
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: Item?
    
    private let placeholder: LocalizedStringKey
    private let collection: [Item]
    
    // MARK: - Body
    
    public var body: some View {
        Menu {
            ForEach(collection, id: \.id) { item in
                Button {
                    value = item
                } label: {
                    Text(item.titleKey)
                        .frame(maxWidth: .infinity)
                        .font(appearance.textFieldFont)
                        .multilineTextAlignment(.leading)
                }
            }
        } label: {
            Text(value?.titleKey ?? placeholder)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: value != nil))
                .multilineTextAlignment(.leading)
        }
        .focused($focused)
        .padding(10)
        .disabled(!isEnabled)
        .overlay(alignment: .bottom) {
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            }
        }
        .overlay(alignment: .trailing) {
            if isEnabled {
                Image(systemName: focused ? "chevron.up" : "chevron.down")
                    .foregroundColor(focused ? appearance.activeBorderColor : appearance.inactiveBorderColor)
                    .animation(.spring(), value: focused)
                    .padding(.trailing, 10)
            }
        }
    }
    
}

extension FormValidationContent where Self == FormPickerValidationView<Value> {
    
    /// A single item picker. An Item should be a valid member of the collection.
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   - collection: The set of items.
    /// - Returns: <#description#>
    public static func itemPicker<Item : AnyItem>(value: Binding<Item?>, placeholder: LocalizedStringKey, collection: [Item]) -> FormPickerValidationView<Item> {
        FormPickerValidationView(value: value, placeholder: placeholder, collection: collection)
    }
}
