//
//  FormValidationView.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public struct FormValidationView<Content, Value> : View  where Content : View, Value : Equatable {
    private let configuration: FormValidationStyleConfiguration
    
    // MARK: - Initializer
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<Value>, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = [], @ViewBuilder content: (_ appearance: FormValidationViewAppearance) -> Content) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self._value = value
        self.trigger = trigger
        self.validators = validators
        
        let appearance: FormValidationViewAppearance = .default
        configuration = FormValidationStyleConfiguration(
            isRequired: isRequired,
            content: content(appearance),
            appearance: appearance
        )
    }
    
    // MARK: - View Binding Properties
    
    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid
    @Binding public var value: Value
    
    // MARK: - Public Properties
    
    public var header: String
    public var leftFooterMessage: String
    public var rightFooterMessage: String
    
    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator]
    
    // MARK: - Body
    
    public var body: some View {
        DefaultFormValidationStyle()
            .makeBody(configuration: configuration)
            .onChange(of: value) { _ in
                validate()
            }
            .onReceive(trigger.publisher) { _ in
                validate()
            }
    }
    
    // MARK: - Validator
    
    public func validate() {
        validationResult = validators.validate(value)
    }
    
}
