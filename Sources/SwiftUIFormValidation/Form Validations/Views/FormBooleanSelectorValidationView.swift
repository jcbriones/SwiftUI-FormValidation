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
    
    public init(value: Binding<Bool>, enabledText: String, disabledText: String) {
        self._value = value
        self.enabledText = enabledText
        self.disabledText = disabledText
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Binding public var value: Bool
    
    private let enabledText: String
    private let disabledText: String
    
    // MARK: - Body
    
    public var body: some View {
        HStack {
            Button(enabledText) {
                withAnimation {
                    value = true
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(value)
            Button(disabledText) {
                withAnimation {
                    value = false
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle(appearance: appearance))
                .disabled(!value)
        }.padding(.vertical, 5)
            .padding(.horizontal, 10)
    }
}

extension FormValidationContent where Self == FormBooleanSelectorValidationView {
    
    /// New boolean form
    public static func boolean(value: Binding<Bool>, enabledText: String, disabledText: String) -> FormBooleanSelectorValidationView {
        FormBooleanSelectorValidationView(value: value, enabledText: enabledText, disabledText: disabledText)
    }
}
