//
//  FormPickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct FormPickerValidationView<Item>: FormValidationView where Item: AnyChip {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<Item?>, placeholder: LocalizedStringKey, collection: [Item], trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.placeholder = placeholder
        self.collection = collection
        self.trigger = trigger
        self.validators = validators
    }

    // MARK: - Private Properties

    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    public let header: String
    public var leftFooterMessage: String = ""
    public var rightFooterMessage: String = ""
    public var isRequired: Bool = false
    @Binding public var value: Item?

    public var placeholder: LocalizedStringKey
    public var collection: [Item]

    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator] = []

    // MARK: - Body

    public var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
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
                    .background(appearance.formValidationColor(focused: focused, validationResult: validationResult))
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

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(value)
    }

}
