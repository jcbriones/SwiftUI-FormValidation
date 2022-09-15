//
//  FormBooleanSelectorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct FormBooleanSelectorValidationView: FormValidationView {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<Bool>, enabledText: String, disabledText: String, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = [], appearance: FormValidationViewAppearanceProtocol? = nil) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.enabledText = enabledText
        self.disabledText = disabledText
        self.trigger = trigger
        self.validators = validators
        self.appearance = appearance ?? FormValidationViewAppearance()
    }
    
    // MARK: - Private Properties
    
    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid
    
    // MARK: - Public Properties
    
    public let header: String
    public var leftFooterMessage: String = ""
    public var rightFooterMessage: String = ""
    public var isRequired: Bool = false
    @Binding public var value: Bool
    
    public var enabledText: String
    public var disabledText: String
    
    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator] = []
    
    public var appearance: FormValidationViewAppearanceProtocol
    
    // MARK: - Body
    
    public var body: some View {
        createView(innerBody)
    }
    
    var innerBody: some View {
        HStack {
            Button(enabledText) {
                withAnimation {
                    value = true
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle())
                .disabled(value)
            Button(disabledText) {
                withAnimation {
                    value = false
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle())
                .disabled(!value)
        }.padding(.vertical, 5)
            .padding(.horizontal, 10)
    }
    
    // MARK: - Validator
    
    public func validate() {
        validationResult = validators.validate(value)
    }
    
}
