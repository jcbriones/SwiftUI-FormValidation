//
//  FormFieldContentModifier.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/22/25.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormFieldContentModifier<Value: Equatable & Sendable>: ViewModifier {
    // MARK: - View Binding Properties

    @Environment(\.externalValidationResult)
    @Binding private var externalFormValidationResult

    @Environment(\.externalValidator)
    private var externalValidator

    @Environment(\.formAppearance)
    private var appearance

    @Environment(\.isEnabled)
    private var isEnabled

    @State private var result: FormValidationResult = .valid
    @FocusState private var focused: Bool

    // MARK: - Form Validation Properties

    @Binding private var value: Value
    private var model: FormModel<Value>

    // MARK: - Body

    public func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            FormFieldTopView(
                value: $value,
                header: model.header,
                isRequired: model.validators.contains(where: { $0 is RequiredFieldValidator })
            )
            content
                .environment(\.formValidationResult, result)
                .focused($focused)
                .formAppearance(appearance)
                .padding(.vertical, 3)
            FormFieldBottomView(
                value: $value,
                result: $result,
                validators: model.validators,
                footerMessage: model.footer
            )
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Initializer

    /// Creates a form validation field view.
    /// - Parameters:
    ///   - value: The value of the content
    ///   - header: The title header of the validation field.
    public init(
        _ value: Binding<Value>,
        model: FormModel<Value>
    ) {
        self._value = value
        self.model = model
    }
}
