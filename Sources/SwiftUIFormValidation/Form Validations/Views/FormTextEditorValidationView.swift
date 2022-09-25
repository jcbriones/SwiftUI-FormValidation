//
//  FormTextEditorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextEditorValidationView: FormValidationProtocol {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<String>, placeholder: String = "", maxCharCount: Int? = nil, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.placeholder = placeholder
        self.maxCharCount = maxCharCount
        self.trigger = trigger
        self.validators = validators
    }
    
    // MARK: - Private Properties
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding private var value: String
    
    private let placeholder: String
    private let maxCharCount: Int?
    
    // MARK: - FormValidationProtocol Properties
    
    private let header: String
    private let leftFooterMessage: String
    private let rightFooterMessage: String
    private let isRequired: Bool
    private let trigger: AnyPublisher<Void, Never>?
    private let validators: [FormValidator]
    
    // MARK: - Body
    
    public var body: some View {
        FormValidationView(header: header, leftFooterMessage: leftFooterMessage, rightFooterMessage: rightFooterMessage, isRequired: isRequired, value: $value, trigger: trigger, validators: validators, content: content)
    }
    
    public func content(_ appearance: FormValidationViewAppearance) -> some View {
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
                    .stroke(appearance.formValidationColor(focused: focused, validationResult: validationResult))
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
