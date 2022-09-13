//
//  FormDatePickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
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
struct FormDatePickerValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: Date

    var imageName: String?
    var placeholder: LocalizedStringKey = ""

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(AppColor.lightGray)
            }
            DatePicker("", selection: $value, in: PartialRangeFrom(.now))
                .labelsHidden()
                .datePickerStyle(.compact)
                .focused($focused)
                .disabled(!isEnabled)
        }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
