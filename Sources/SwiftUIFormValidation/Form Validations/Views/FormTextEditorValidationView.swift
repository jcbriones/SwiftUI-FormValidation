//
//  FormTextEditorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextEditorValidationView: FormValidationContent {
    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult) private var validationResult
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @Binding public var value: String

    private let placeholder: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
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
#if os(iOS)
            .keyboardType(.asciiCapable)
            .border(.clear, width: 0)
#endif
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
#if os(iOS)
                UITextView.appearance().backgroundColor = .clear
#endif
            }
    }

    // MARK: - Initializer

    init(value: Binding<String>, placeholder: LocalizedStringKey = "") {
        self._value = value
        self.placeholder = placeholder
    }
}

public extension FormValidationContent where Self == FormTextEditorValidationView {
    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    static func textEditor(
        value: Binding<String>,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextEditorValidationView {
        FormTextEditorValidationView(value: value, placeholder: placeholder)
    }

    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    static func textEditor(
        value: Binding<String>,
        placeholder: String = ""
    ) -> FormTextEditorValidationView {
        FormTextEditorValidationView(value: value, placeholder: .init(placeholder))
    }

    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    static func textEditor(
        value: Binding<String?>,
        placeholder: LocalizedStringKey = ""
    ) -> FormTextEditorValidationView {
        FormTextEditorValidationView(
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

    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    static func textEditor(
        value: Binding<String?>,
        placeholder: String = ""
    ) -> FormTextEditorValidationView {
        FormTextEditorValidationView(
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
