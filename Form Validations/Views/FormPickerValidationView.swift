//
//  FormPickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

/**
 Allows to create a custom text field that is used in forms.
 This allows to create a text field with specific type.
 The form field types are declared in `FormFieldType` and the default value is `.asciiTextField`.
 For examples on how to use the this, check `FormTextFieldValidationView_Previews` and look at different examples.
 */
struct FormPickerValidationView<Item>: FormValidationView where Item: AnyChip {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: Item?

    var placeholder: LocalizedStringKey
    var collection: [Item]

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
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
                        .textStyle(.body1)
                        .multilineTextAlignment(.leading)
                }
            }
        } label: {
            Text(value?.titleKey ?? placeholder)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textStyle(.body1, foregroundColor: AppColor.formTextColor(isEnabled: value != nil))
                .multilineTextAlignment(.leading)
        }
        .focused($focused)
        .padding(10)
        .disabled(!isEnabled)
        .overlay(alignment: .bottom) {
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(AppColor.formValidationColor(focused: focused, validationResult: validationResult))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            }
        }
        .overlay(alignment: .trailing) {
            if isEnabled {
                Image(systemName: focused ? "chevron.up" : "chevron.down")
                    .foregroundColor(focused ? AppColor.accent : AppColor.darkGray)
                    .animation(.spring(), value: focused)
                    .padding(.trailing, 10)
            }
        }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
