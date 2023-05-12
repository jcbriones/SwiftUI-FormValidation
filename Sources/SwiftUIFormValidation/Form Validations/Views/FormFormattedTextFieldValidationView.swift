//
//  FormFormattedTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormFormattedTextFieldValidationView<F>: FormValidationContent
where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable {

    // MARK: - Initializer

    init(value: Binding<F.FormatInput?>, formatter: F, imageName: String? = nil, placeholder: LocalizedStringKey = "") {
        self._value = value
        self.formatter = formatter
        self.imageName = imageName
        self.placeholder = placeholder
    }

    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: F.FormatInput?

    private let formatter: F
    private let imageName: String?
    private let placeholder: LocalizedStringKey

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
                TextField(placeholder, value: $value, format: formatter)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .focused($focused)
                    .disabled(!isEnabled)
                    .keyboardType(keyboardTypeFromFormatInput)
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

    private var keyboardTypeFromFormatInput: UIKeyboardType {
        switch F.FormatInput.self {
        case is any Numeric:
            return .numberPad
        default:
            return .default
        }
    }

}

public extension FormValidationContent {
    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - formatter: The formatter to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func formattedTextField<F>(
        value: Binding<Value>,
        formatter: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormFormattedTextFieldValidationView<F>
    where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable,
          Value == F.FormatInput?, Self == FormFormattedTextFieldValidationView<F> {
              FormFormattedTextFieldValidationView(
                value: value,
                formatter: formatter,
                imageName: imageName,
                placeholder: placeholder
              )
          }

    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - formatter: The formatter to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func formattedTextField<F>(
        value: Binding<Value>,
        formatter: F,
        imageName: String? = nil,
        placeholder: String = ""
    ) -> FormFormattedTextFieldValidationView<F>
    where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable,
          Value == F.FormatInput?, Self == FormFormattedTextFieldValidationView<F> {
              FormFormattedTextFieldValidationView(
                value: value,
                formatter: formatter,
                imageName: imageName,
                placeholder: .init(placeholder)
              )
          }
}
