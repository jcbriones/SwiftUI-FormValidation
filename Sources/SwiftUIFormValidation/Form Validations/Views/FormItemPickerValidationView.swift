//
//  FormItemPickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormItemPickerValidationView<Item>: FormValidationContent where Item: AnyItem {
    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: Item?

    private let placeholder: LocalizedStringKey
    private let collection: [Item]

    // MARK: - Body

    public var body: some View {

        VStack(spacing: 0) {
            Menu {
                ForEach(collection, id: \.id) { item in
                    Button {
                        value = item
                    } label: {
                        Text(item.localizedString)
                            .frame(maxWidth: .infinity)
                            .font(appearance.textFieldFont)
                            .multilineTextAlignment(.leading)
                    }
                }
            } label: {
                Text(value?.localizedString ?? placeholder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: value != nil))
                    .multilineTextAlignment(.leading)
            }
            .focused($focused)
            .padding(10)
            .disabled(!isEnabled)
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(
                        appearance.formValidationBorderColor(
                            focused: focused,
                            validationResult: validationResult
                        )
                    )
                    .animation(appearance.animation, value: focused)
                    .animation(appearance.animation, value: validationResult)
            }
        }
        .overlay(alignment: .trailing) {
            if isEnabled {
                Image(systemName: focused ? "chevron.up" : "chevron.down")
                    .foregroundColor(focused ? appearance.activeBorderColor : appearance.inactiveBorderColor)
                    .animation(appearance.animation, value: focused)
                    .padding(.trailing, 10)
            }
        }
    }

    // MARK: - Initializer

    init(value: Binding<Item?>, placeholder: LocalizedStringKey, collection: [Item]) {
        self._value = value
        self.placeholder = placeholder
        self.collection = collection
    }
}

public extension FormValidationContent {
    /// A single item picker. An Item should be a valid member of the collection.
    /// - Parameters:
    ///   - value: Any item inside the collection.
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   - collection: The set of items.
    static func itemPicker<Item>(
        value: Binding<Value>,
        placeholder: LocalizedStringKey,
        collection: [Item]
    ) -> FormItemPickerValidationView<Item>
    where Item: AnyItem, Value == Item?, Self == FormItemPickerValidationView<Item> {
        FormItemPickerValidationView(value: value, placeholder: placeholder, collection: collection)
    }

    /// A single item picker. An Item should be a valid member of the collection.
    /// - Parameters:
    ///   - value: Any item inside the collection.
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   - collection: The set of items.
    static func itemPicker<Item>(
        value: Binding<Value>,
        placeholder: String,
        collection: [Item]
    ) -> FormItemPickerValidationView<Item>
    where Item: AnyItem, Value == Item?, Self == FormItemPickerValidationView<Item> {
        FormItemPickerValidationView(value: value, placeholder: LocalizedStringKey(placeholder), collection: collection)
    }
}
