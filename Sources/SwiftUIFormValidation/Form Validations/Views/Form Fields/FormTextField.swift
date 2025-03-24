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
        header: LocalizedStringKey? = nil,
        imageName: String? = nil,
        systemName: String? = nil,
        placeholder: LocalizedStringKey = ""
    ) {
        self._value = value
        self.model = .init(header: header)
        self.imageName = imageName
        self.systemName = systemName
        self.placeholder = placeholder
    }
}
