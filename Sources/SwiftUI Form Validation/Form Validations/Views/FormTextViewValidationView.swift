//
//  FormTextViewValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
struct FormTextViewValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: String

    var placeholder: String = ""
    var maxCharCount: Int?

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        TextEditor(text: $value)
            .disabled(!isEnabled)
            .focused($focused)
            .cornerRadius(10)
            .padding(1)
            .font(appearance.textFieldFont)
            .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
            .frame(minHeight: 140)
            .multilineTextAlignment(.leading)
            .disableAutocorrection(true)
            .keyboardType(.asciiCapable)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                    .background((isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor).cornerRadius(10))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            )
            .overlay(alignment: .topLeading) {
                if value.isEmpty && !focused {
                    Text(placeholder)
                        .font(appearance.textFieldFont)
                        .foregroundColor(appearance.placeholderTextColor)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                        .onTapGesture {
                            focused.toggle()
                        }
                }
            }
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
