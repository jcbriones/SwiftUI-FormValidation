//
//  FormTextField.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormTextField: FormValidationContent {
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

    private let imageName: String?
    private let systemName: String?
    private let placeholder: LocalizedStringResource

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
            TextField(String(localized: placeholder), text: $value)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                .multilineTextAlignment(.leading)
                .focused($focused)
                .disabled(!isEnabled)
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

    // MARK: - Initializer

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    public init(
        _ value: Binding<String>,
        header: LocalizedStringResource? = nil,
        imageName: String? = nil,
        systemName: String? = nil,
        placeholder: LocalizedStringResource = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.imageName = imageName
        self.systemName = systemName
        self.placeholder = placeholder
    }

    /// The text field
    /// - Parameters:
    ///   - value: The text to display
    ///   - header: The name of this form field.
    ///   - imageName: Allows to add an image beginning of the text  inside the text field.
    ///   - systemName: Allows to add an image beginning of the text  inside the text field.
    ///   - placeholder: The text placeholder
    public init(
        _ value: Binding<String?>,
        header: LocalizedStringResource? = nil,
        imageName: String? = nil,
        systemName: String? = nil,
        placeholder: LocalizedStringResource = ""
    ) {
        self._value = Binding(
            get: { value.wrappedValue ?? "" },
            set: { newValue in value.wrappedValue = newValue.isEmpty ? nil : newValue }
        )
        self.model = .init(header: header)
        self.imageName = imageName
        self.systemName = systemName
        self.placeholder = placeholder
    }
}
