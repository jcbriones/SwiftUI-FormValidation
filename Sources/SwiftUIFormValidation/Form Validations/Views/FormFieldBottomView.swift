//
//  FormFieldBottomView.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/23/25.
//  Copyright © 2025 PetCollab, LLC. All rights reserved.
//

import SwiftUI

struct FormFieldBottomView<Value: Equatable>: View {
    @Environment(\.formAppearance)
    private var appearance
    @Environment(\.isFocused)
    private var isFocused
    @Environment(\.externalValidationResult)
    @Binding private var externalFormValidationResult
    @Environment(\.externalValidator)
    private var externalValidator

    // MARK: - Properties

    @State private var trailingFooter: String = ""
    @State private var shake: Bool = false

    @Binding var value: Value
    @Binding var result: FormValidationResult
    var validators: [any FormValidator]
    var footerMessage: LocalizedStringKey?

    // MARK: - Body

    var body: some View {
        HStack {
            switch result {
            case .valid:
                Text(footerMessage ?? " ")
                    .font(appearance.validatedDescriptionFont)
                    .foregroundColor(
                        appearance.formValidationDescriptionTextColor(
                            focused: isFocused,
                            validationResult: result
                        )
                    )
                    .accessibilityHidden(footerMessage == nil)
            case .info(let message), .warning(let message), .error(let message):
                Text(message, bundle: .module)
                    .font(appearance.validatedDescriptionFont)
                    .foregroundColor(
                        appearance.formValidationDescriptionTextColor(
                            focused: isFocused,
                            validationResult: result
                        )
                    )
                    .shake(shake, offsetRange: 3)
                    .onAppear {
                        if !result.isValid {
                            shake.toggle()
                        }
                    }
            }
            Spacer()
            if !trailingFooter.isEmpty {
                Text(trailingFooter)
                    .font(appearance.validatedDescriptionFont)
                    .foregroundColor(appearance.activeTextColor)
            } else if let validator = validators.first(where: { $0 is CharacterLimitValidator }) as? CharacterLimitValidator,
                      let text = value as? CustomStringConvertible {
                Text("\(text.description.count.formatted()) / \(validator.characterLimit.formatted())")
                    .font(appearance.validatedDescriptionFont)
                    .foregroundColor(
                        text.description.count <= validator.characterLimit ?
                        appearance.activeTextColor :
                            appearance.formValidationBorderColor(
                                focused: isFocused,
                                validationResult: result
                            )
                    )
            }
        }
        .padding(.bottom, 3)
        .onChange(of: value) { newValue in
            result = validators.validate(newValue).first { $0 != .valid } ?? .valid
        }
        .onReceive(externalValidator) {
            result = validators.validate(value).first { $0 != .valid } ?? .valid
        }
        .onAppear {
            externalFormValidationResult = .valid
        }
        .onDisappear {
            externalFormValidationResult = nil
        }
        .onChange(of: result) { newValue in
            externalFormValidationResult = newValue
        }
    }
}

