//
//  FormValidationView.swift
//
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public struct FormValidationView: View {
    
    // MARK: - Initializer
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = [], @ViewBuilder content: () -> some FormValidationContent) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self.trigger = trigger
        self.validators = validators

        self.content = content().formAppearance(configuration.appearance)
    }

    // MARK: - View Binding Properties

    @Environment(\.formValidationStyle) private var configuration: FormValidationStyleConfiguration
    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid
    @State public var content: FormValidationContent = {
        EmptyView()
    }

    // MARK: - Public Properties

    public var header: String
    public var leftFooterMessage: String
    public var rightFooterMessage: String
    public var isRequired: Bool

    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator]

    // MARK: - Body

    public var body: some View {
        DefaultFormValidationStyle()
            .makeBody(configuration: configuration)
            .onChange(of: content.value) { _ in
                validate()
            }
            .onReceive(trigger.publisher) { _ in
                validate()
            }
    }

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(content.value)
    }

}
