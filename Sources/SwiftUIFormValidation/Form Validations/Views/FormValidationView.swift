//
//  FormValidationView.swift
//
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public struct FormValidationView<Content> : View where Content : FormValidationContent {
    
    // MARK: - Initializer
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = [], _ contentType: Content) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self.trigger = trigger
        self.validators = validators

        self.contentType = contentType
    }

    // MARK: - View Binding Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    private var contentType: Content

    // MARK: - Form Validation Properties

    private var header: String
    private var leftFooterMessage: String
    private var rightFooterMessage: String
    private var isRequired: Bool

    private var trigger: AnyPublisher<Void, Never>?
    private var validators: [FormValidator]

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if isRequired {
                    (Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor)
                     +
                     Text(" *")
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(appearance.requiredFieldSymbolTextColor))
                    .animation(.easeInOut(duration: 0.5), value: focused)
                } else {
                    Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor)
                        .animation(.easeInOut(duration: 0.5), value: focused)
                }
            }.accessibilityAddTraits([.isHeader])
            contentType
                .formAppearance(appearance)
                .padding(.vertical, 3)
            HStack {
                switch validationResult {
                case .valid:
                    Text(leftFooterMessage)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                        .accessibilityHidden(leftFooterMessage.isEmpty)
                case .info(let message), .warning(let message), .error(let message):
                    Text(message)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                }
                Spacer()
                if !rightFooterMessage.isEmpty {
                    Text(rightFooterMessage)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: validationResult)
                }
            }
        }
        .onChange(of: contentType.value) { _ in
            validate()
        }
        .onReceive(trigger.publisher) { _ in
            validate()
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(contentType.value)
    }

}
