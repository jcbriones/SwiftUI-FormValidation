//
//  FormTextFieldFormattedValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public struct FormTextFieldFormattedValidationView<F>: FormValidationView where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable {
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<F.FormatInput?> = .constant(nil), formatter: F, imageName: String? = nil, placeholder: LocalizedStringKey = "", trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
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

    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    public let header: String
    public var leftFooterMessage: String = ""
    public var rightFooterMessage: String = ""
    public var isRequired: Bool = false
    @Binding public var value: F.FormatInput?

    public var formatter: F
    public var imageName: String?
    public var placeholder: LocalizedStringKey = ""

    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator] = []

    // MARK: - Body

    public var body: some View {
        createView(innerBody)
    }

    public var innerBody: some View {
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

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(value)
    }

}
