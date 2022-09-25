//
//  FormBooleanSelectorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormBooleanSelectorValidationView: FormValidationProtocol {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<Bool>, enabledText: String, disabledText: String, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.enabledText = enabledText
        self.disabledText = disabledText
        self.trigger = trigger
        self.validators = validators
    }
    
    // MARK: - Private Properties
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding private var value: Bool
    
    private let enabledText: String
    private let disabledText: String
    
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
