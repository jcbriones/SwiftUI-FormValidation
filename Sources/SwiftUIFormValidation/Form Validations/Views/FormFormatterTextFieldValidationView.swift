//
//  FormFormattedTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 9/7/23.
//  Copyright © 2023 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormFormatterTextFieldValidationView<F, V>: FormValidationContent where F: Formatter, V: Equatable {

    // MARK: - Initializer

    init(value: Binding<V?>, formatter: F, imageName: String? = nil, placeholder: LocalizedStringKey = "") {
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
    @Binding public var value: V?

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
                TextField(placeholder, value: $value, formatter: formatter)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .focused($focused)
                    .disabled(!isEnabled)
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
        switch V.self {
        case is any Numeric:
            return .numberPad
        default:
            return .default
        }
    }
#endif

}

public extension FormValidationContent {
    /// Allows to format the text of the text field after resigning from responder.
    /// - Parameters:
    ///   - value: The text to display
    ///   - formatter: The formatter to use to format the text.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func formatterTextField<F, V>(
        value: Binding<V?>,
        formatter: F,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormFormatterTextFieldValidationView<F, V>
    where F: Formatter, Self == FormFormatterTextFieldValidationView<F, V> {
        FormFormatterTextFieldValidationView(
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
    static func formatterTextField<F, V>(
        value: Binding<V?>,
        formatter: F,
        imageName: String? = nil,
        placeholder: String = ""
    ) -> FormFormatterTextFieldValidationView<F, V>
    where F: Formatter, Self == FormFormatterTextFieldValidationView<F, V> {
        FormFormatterTextFieldValidationView(
            value: value,
            formatter: formatter,
            imageName: imageName,
            placeholder: .init(placeholder)
        )
    }
}
