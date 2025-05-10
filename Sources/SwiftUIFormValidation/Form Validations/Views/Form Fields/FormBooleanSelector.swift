//
//  FormBooleanSelector.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormBooleanSelector: FormValidationContent {
    @Environment(\.formAppearance)
    private var appearance: FormValidationViewAppearance

    // MARK: - FormValidationContent Properties

    @Binding public var value: Bool
    public var model: FormModel<Value>

    // MARK: - Form Field Properties

    private let textForNo: LocalizedStringKey
    private let textForYes: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        HStack {
            Button(textForNo) {
                value = false
            }
            .buttonStyle(FormPickerCapsuleButtonStyle(isSelected: !value))
            .animation(appearance.animation, value: value)
            Button(textForYes) {
                value = true
            }
            .buttonStyle(FormPickerCapsuleButtonStyle(isSelected: value))
            .animation(appearance.animation, value: value)
        }
        .padding(
            .init(
                top: appearance.topPadding,
                leading: appearance.leadingPadding,
                bottom: appearance.bottomPadding,
                trailing: appearance.trailingPadding
            )
        )
        .modifier(FormFieldContentModifier($value, model: model))
    }

    // MARK: - Initializer

    /// A form validation that supports a boolean value.
    /// - Parameters:
    ///   - value: If set to true, the true button is selected. Otherwise, the false button is selected.
    ///   - header: The name of this form field.
    ///   - enabledText: The text to display on the button where the value is set to true.
    ///   - disabledText: The text to display on the button where the value is set to false.
    public init(
        _ value: Binding<Bool>,
        header: LocalizedStringKey? = nil,
        textForNo: LocalizedStringKey,
        textForYes: LocalizedStringKey
    ) {
        self._value = value
        self.model = .init(header: header)
        self.textForNo = textForNo
        self.textForYes = textForYes
    }
}
