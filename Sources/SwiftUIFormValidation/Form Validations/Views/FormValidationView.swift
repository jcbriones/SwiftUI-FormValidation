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
    public init(header: LocalizedStringKey,
                footerMessage: LocalizedStringKey? = nil,
                isRequired: Bool = false,
                validators: [FormValidator] = [],
                _ contentType: Content) {
        self.header = header
        self.footerMessage = footerMessage
        self.isRequired = isRequired
        self.validators = validators
        self.contentType = contentType
    }

    // MARK: - View Binding Properties

    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    private var trigger: AnyPublisher<Void, Never>?

    // MARK: - Form Validation Properties

    private var header: LocalizedStringKey
    private var footerMessage: LocalizedStringKey?
    @State private var trailingFooter: String = ""
    private var isRequired: Bool
    private var validators: [FormValidator]
    private var contentType: Content

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
                    .animation(appearance.animation, value: focused)
                } else {
                    Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(focused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor)
                        .animation(appearance.animation, value: focused)
                }
            }.accessibilityAddTraits([.isHeader])
            contentType
                .formAppearance(appearance)
                .padding(.vertical, 3)
            HStack {
                switch validationResult {
                case .valid:
                    Text(footerMessage ?? "")
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(appearance.animation, value: validationResult)
                        .accessibilityHidden(footerMessage == nil)
                case .info(let message), .warning(let message), .error(let message):
                    Text(message)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(appearance.animation, value: validationResult)
                }
                Spacer()
                if !trailingFooter.isEmpty {
                    Text(trailingFooter)
                        .font(appearance.validatedDescriptionFont)
                        .foregroundColor(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                        .frame(minHeight: 15)
                        .animation(appearance.animation, value: validationResult)
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
