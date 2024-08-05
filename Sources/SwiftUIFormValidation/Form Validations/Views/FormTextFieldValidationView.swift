//
//  FormTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextFieldValidationView: FormValidationContent {
    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: String

    private let imageName: String?
    private let systemName: String?
    private let placeholder: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let imageName {
                    Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27)
                        .foregroundColor(appearance.imageIconColor)
                }
                if let systemName {
                    Image(systemName: systemName).resizable().scaledToFit().frame(width: 27, height: 27)
                        .foregroundColor(appearance.imageIconColor)
                }
                TextField(placeholder, text: $value)
                    .font(appearance.textFieldFont)
                    .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .focused($focused)
                    .disabled(!isEnabled)
            }
            Divider()
                .frame(height: focused ? 2 : 1.5)
                .background(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                .animation(appearance.animation, value: focused)
                .animation(appearance.animation, value: validationResult)
        }
    }

    // MARK: - Initializer

    init(
        value: Binding<String>,
        imageName: String? = nil,
        systemName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.imageName = imageName
        self.systemName = systemName
        self.placeholder = placeholder
    }
}

public extension FormValidationContent where Self == FormTextFieldValidationView {
    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: value,
            imageName: imageName,
            placeholder: placeholder
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        systemName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: value,
            systemName: systemName,
            placeholder: placeholder
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(value: value, placeholder: placeholder)
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        imageName: String? = nil,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: value,
            imageName: imageName,
            placeholder: .init(placeholder)
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        systemName: String? = nil,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: value,
            systemName: systemName,
            placeholder: .init(placeholder)
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String>,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: value,
            placeholder: .init(placeholder)
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        imageName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            imageName: imageName,
            placeholder: placeholder
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        systemName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            systemName: systemName,
            placeholder: placeholder
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            placeholder: placeholder
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        imageName: String? = nil,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            imageName: imageName,
            placeholder: .init(placeholder)
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        systemName: String? = nil,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            systemName: systemName,
            placeholder: .init(placeholder)
        )
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    static func textField(
        value: Binding<String?>,
        placeholder: String = ""
    ) -> FormTextFieldValidationView {
        FormTextFieldValidationView(
            value: Binding(
                get: { value.wrappedValue ?? "" },
                set: {
                    let newValue = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    value.wrappedValue = newValue.isEmpty ? nil : $0
                }
            ),
            placeholder: .init(placeholder)
        )
    }
}
