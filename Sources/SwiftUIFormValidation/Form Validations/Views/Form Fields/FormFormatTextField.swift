//
//  FormFormatTextField.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormFormatTextField<F>: FormValidationContent
where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable & Sendable {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult)
    private var validationResult
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    @FocusState private var focused: Bool

    // MARK: - FormValidationContent Properties

    @Binding public var value: F.FormatInput?
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    private let format: F
    private let imageName: String?
    private let systemName: String?
    private let placeholder: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 5) {
            if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                    .foregroundColor(appearance.imageIconColor)
            }
            if let systemName {
                Image(systemName: systemName)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.imageIconColor)
            }
            TextField(placeholder, value: $value, format: format)
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
            RoundedRectangle(cornerRadius: appearance.borderRadius, style: .continuous)
                .stroke(
                    appearance.formValidationBorderColor(
                        focused: focused,
                        validationResult: validationResult
                    ),
                    lineWidth: focused ? appearance.borderWidthActive : appearance.borderWidthInactive
                )
                .background(
                    (
                        isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor
                    )
                    .cornerRadius(appearance.borderRadius)
                )
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        )
        .modifier(FormFieldContentModifier($value, model: model))
    }

#if os(iOS)
    private var keyboardTypeFromFormatInput: UIKeyboardType {
        switch F.FormatInput.self {
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
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - format: The format to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    public init(
        _ value: Binding<F.FormatInput?>,
        header: LocalizedStringKey? = nil,
        format: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.format = format
        self.imageName = imageName
        self.systemName = nil
        self.placeholder = placeholder
    }

    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - format: The format to use to format the text.
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    public init(
        _ value: Binding<F.FormatInput?>,
        header: LocalizedStringKey? = nil,
        format: F,
        systemName: String?,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.format = format
        self.imageName = nil
        self.systemName = systemName
        self.placeholder = placeholder
    }
}
