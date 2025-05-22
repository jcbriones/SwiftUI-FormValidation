//
//  FormTextEditor.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormTextEditor: FormValidationContent {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance
    @Environment(\.formValidationResult)
    private var validationResult
    @Environment(\.isEnabled)
    private var isEnabled: Bool

    @FocusState private var focused: Bool

    // MARK: - FormValidationContent Properties

    @Binding public var value: String
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    private let placeholder: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        TextEditor(text: $value)
            .disabled(!isEnabled)
            .focused($focused)
            .cornerRadius(appearance.borderRadius)
            .font(appearance.textFieldFont)
            .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
            .frame(minHeight: 140)
            .scrollContentBackground(.hidden)
            .padding(.vertical, -10)
            .padding(.horizontal, -5)
            .multilineTextAlignment(.leading)
            .disableAutocorrection(true)
#if os(iOS)
            .keyboardType(.asciiCapable)
            .border(.clear, width: 0)
#endif
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
            .overlay(alignment: .topLeading) {
                if value.isEmpty && !focused {
                    Text(placeholder)
                        .font(appearance.textFieldFont)
                        .foregroundColor(appearance.placeholderTextColor)
                        .padding(
                            .init(
                                top: appearance.topPadding,
                                leading: appearance.leadingPadding,
                                bottom: appearance.bottomPadding,
                                trailing: appearance.trailingPadding
                            )
                        )
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
            .modifier(FormFieldContentModifier($value, model: model))
    }

    // MARK: - Initializer

    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    public init(
        _ value: Binding<String>,
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.placeholder = placeholder
    }

    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   Set to `nil` to disable checking
    public init(
        _ value: Binding<String?>,
        header: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = Binding(
            get: { value.wrappedValue ?? "" },
            set: { newValue in value.wrappedValue = newValue.isEmpty ? nil : newValue }
        )
        self.model = .init(header: header)
        self.placeholder = placeholder
    }
}
