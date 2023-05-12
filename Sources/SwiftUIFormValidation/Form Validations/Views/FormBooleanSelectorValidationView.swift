//
//  FormBooleanSelectorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormBooleanSelectorValidationView: FormValidationContent {

    // MARK: - Initializer

    init(value: Binding<Bool>, textForNo: LocalizedStringKey, textForYes: LocalizedStringKey) {
        self._value = value
        self.textForNo = textForNo
        self.textForYes = textForYes
    }

    // MARK: - Private Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Binding public var value: Bool

    private let textForYes: LocalizedStringKey
    private let textForNo: LocalizedStringKey

    // MARK: - Body

    public var body: some View {
        HStack {
            Button(textForNo) {
                value = false
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(!value)
                .animation(appearance.animation, value: value)
            Button(textForYes) {
                value = true
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(value)
                .animation(appearance.animation, value: value)
        }.padding(.vertical, 5)
            .padding(.horizontal, 10)
    }
}

public extension FormValidationContent where Self == FormBooleanSelectorValidationView {
    /// A form validation that supports a boolean value.
    /// - Parameters:
    ///   - value: If set to true, the true button is selected. Otherwise, the false button is selected.
    ///   - enabledText: The text to display on the button where the value is set to true.
    ///   - disabledText: The text to display on the button where the value is set to false.
    static func boolean(
        value: Binding<Bool>,
        textForNo: LocalizedStringKey,
        textForYes: LocalizedStringKey
    ) -> FormBooleanSelectorValidationView {
        FormBooleanSelectorValidationView(
            value: value,
            textForNo: textForNo,
            textForYes: textForYes
        )
    }

    /// A form validation that supports a boolean value.
    /// - Parameters:
    ///   - value: If set to true, the true button is selected. Otherwise, the false button is selected.
    ///   - enabledText: The text to display on the button where the value is set to true.
    ///   - disabledText: The text to display on the button where the value is set to false.
    static func boolean(
        value: Binding<Bool>,
        textForNo: String,
        textForYes: String
    ) -> FormBooleanSelectorValidationView {
        FormBooleanSelectorValidationView(
            value: value,
            textForNo: .init(textForNo),
            textForYes: .init(textForYes)
        )
    }
}
