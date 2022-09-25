//
//  FormTextFieldFormattedValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextFieldFormattedValidationView<F>: FormValidationProtocol where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<F.FormatInput?>, formatter: F, imageName: String? = nil, placeholder: LocalizedStringKey = "", trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.formatter = formatter
        self.imageName = imageName
        self.placeholder = placeholder
        self.trigger = trigger
        self.validators = validators
    }
    
    // MARK: - Private Properties
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding private var value: F.FormatInput?
    
    private let formatter: F
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    
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
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(appearance.imageIconColor)
            }
            TextField(placeholder, value: $value, format: formatter)
                .focused($focused)
                .textFieldStyle(LandingTextFieldStyle())
                .disabled(!isEnabled)
        }
        .overlay(alignment: .bottom) {
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            }
        }
    }
    
}
