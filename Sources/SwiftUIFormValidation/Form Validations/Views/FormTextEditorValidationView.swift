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
    
    // MARK: - Initializer
    
    public init(value: Binding<String>, placeholder: String = "", maxCharCount: Int? = nil) {
        self._value = value
        self.placeholder = placeholder
        self.maxCharCount = maxCharCount
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: String
    
    private let placeholder: String
    private let maxCharCount: Int?
    
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
            .keyboardType(.asciiCapable)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                    .background((isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor).cornerRadius(10))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
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
                UITextView.appearance().backgroundColor = .clear
            }
    }
    
}

extension FormValidationContent where Self == FormTextEditorValidationView {
    
    /// Text editor also known as text view in `UIKit`
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - placeholder: Placeholder string if the value is `nil`
    ///   - maxCharCount: The maximum number of characters allowed before it throws an error validation result. Set to `nil` to disable checking
    /// - Returns: <#description#>
    public static func textEditor(value: Binding<String>, placeholder: String = "", maxCharCount: Int? = nil) -> FormTextEditorValidationView {
        FormTextEditorValidationView(value: value, placeholder: placeholder, maxCharCount: maxCharCount)
    }
}
