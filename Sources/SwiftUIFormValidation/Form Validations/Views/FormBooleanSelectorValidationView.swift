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
    
    init(value: Binding<Bool>, enabledText: LocalizedStringKey, disabledText: LocalizedStringKey) {
        self._value = value
        self.enabledText = enabledText
        self.disabledText = disabledText
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Binding public var value: Bool
    
    private let enabledText: LocalizedStringKey
    private let disabledText: LocalizedStringKey
    
    // MARK: - Body
    
    public var body: some View {
        HStack {
            Button(enabledText) {
                value = true
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(value)
                .animation(appearance.animation, value: value)
            Button(disabledText) {
                value = false
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(!value)
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
    static func boolean(value: Binding<Bool>, enabledText: LocalizedStringKey, disabledText: LocalizedStringKey) -> FormBooleanSelectorValidationView {
        FormBooleanSelectorValidationView(value: value, enabledText: enabledText, disabledText: disabledText)
    }

    /// A form validation that supports a boolean value.
    /// - Parameters:
    ///   - value: If set to true, the true button is selected. Otherwise, the false button is selected.
    ///   - enabledText: The text to display on the button where the value is set to true.
    ///   - disabledText: The text to display on the button where the value is set to false.
    static func boolean(value: Binding<Bool>, enabledText: String, disabledText: String) -> FormBooleanSelectorValidationView {
        FormBooleanSelectorValidationView(value: value, enabledText: .init(enabledText), disabledText: .init(disabledText))
    }
}
