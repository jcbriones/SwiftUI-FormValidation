//
//  FormFormatTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormFormatTextFieldValidationView<F>: FormValidationContent
where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable {
    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: F.FormatInput?

    private let format: F
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    private let textCase: Text.Case?

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 27, height: 27)
                        .foregroundColor(appearance.imageIconColor)
                }
                TextField(placeholder, value: $value, format: format)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .focused($focused)
                    .disabled(!isEnabled)
                    .textCase(textCase)
#if os(iOS)
                    .keyboardType(keyboardTypeFromFormatInput)
#endif
            }
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

    init(
        value: Binding<F.FormatInput?>,
        format: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = "",
        textCase: Text.Case? = nil
    ) {
        self._value = value
        self.format = format
        self.imageName = imageName
        self.placeholder = placeholder
        self.textCase = textCase
    }
}

public extension FormValidationContent {
    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - format: The format to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    ///   - textCase: The text casing inside the text field
    static func formatTextField<F>(
        value: Binding<Value>,
        format: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = "",
        textCase: Text.Case? = nil
    ) -> FormFormatTextFieldValidationView<F>
    where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable,
          Value == F.FormatInput?, Self == FormFormatTextFieldValidationView<F> {
              FormFormatTextFieldValidationView(
                value: value,
                format: format,
                imageName: imageName,
                placeholder: placeholder,
                textCase: textCase
              )
          }

    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - format: The format to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    ///   - textCase: The text casing inside the text field
    static func formatTextField<F>(
        value: Binding<Value>,
        format: F,
        imageName: String? = nil,
        placeholder: String = "",
        textCase: Text.Case? = nil
    ) -> FormFormatTextFieldValidationView<F>
    where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable,
          Value == F.FormatInput?, Self == FormFormatTextFieldValidationView<F> {
              FormFormatTextFieldValidationView(
                value: value,
                format: format,
                imageName: imageName,
                placeholder: .init(placeholder),
                textCase: textCase
              )
          }
}
