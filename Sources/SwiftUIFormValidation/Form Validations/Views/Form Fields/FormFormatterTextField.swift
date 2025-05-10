//
//  FormFormatterTextField.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 9/7/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormFormatterTextField<F, V>: FormValidationContent where F: Formatter, V: Equatable & Sendable {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult)
    private var validationResult
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    @FocusState private var focused: Bool

    // MARK: - FormValidationContent Properties

    @Binding public var value: V?
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    private let formatter: F
    private let imageName: String?
    private let placeholder: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 5) {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                    .foregroundColor(appearance.imageIconColor)
            }
            TextField(placeholder, value: $value, formatter: formatter)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                .multilineTextAlignment(.leading)
                .focused($focused)
                .disabled(!isEnabled)
#if os(iOS)
                .keyboardType(keyboardTypeFromFormatInput)
#endif
        }
        .padding(
            .init(
                top: appearance.topPadding,
                leading: appearance.leadingPadding,
                bottom: appearance.bottomPadding,
                trailing: appearance.trailingPadding
            )
        )
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(
                    appearance.formValidationBorderColor(
                        focused: focused,
                        validationResult: validationResult
                    ),
                    lineWidth: focused ? 2 : 1.5
                )
                .background(
                    (
                        isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor
                    )
                    .cornerRadius(10)
                )
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        )
        .modifier(FormFieldContentModifier($value, model: model))
    }

#if os(iOS)
    private var keyboardTypeFromFormatInput: UIKeyboardType {
        switch V.self {
        case is any Numeric:
            return .numberPad
        default:
            return .default
        }
    }
#endif

    // MARK: - Initializer

    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display.
    ///   - header: The name of this form field.
    ///   - formatter: The formatter to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    public init(
        _ value: Binding<V?>,
        header: LocalizedStringKey? = nil,
        formatter: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.formatter = formatter
        self.imageName = imageName
        self.placeholder = placeholder
    }
}
