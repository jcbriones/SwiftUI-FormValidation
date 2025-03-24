//
//  FormItemPicker.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormItemPicker<Item>: FormValidationContent where Item: AnyItem {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult)
    private var validationResult
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    @FocusState private var focused: Bool

    // MARK: - FormValidationContent Properties

    @Binding public var value: Item?
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

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
        .modifier(FormFieldContentModifier($value, model: model))
    }

    // MARK: - Initializer

    /// A single item picker. An Item should be a valid member of the collection.
    /// - Parameters:
    ///   - value: Any item inside the collection.
    ///   - header: The name of this form field.   
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   - collection: The set of items.
    public init(
        _ value: Binding<Item?>,
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey,
        collection: [Item]
    ) {
        self._value = value
        self.model = .init(header: header)
        self.placeholder = placeholder
        self.collection = collection
    }
}
