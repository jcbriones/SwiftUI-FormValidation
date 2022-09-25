//
//  FormValidationStyleConfiguration.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public struct FormValidationStyleConfiguration : FormValidation {
    
    public typealias Appearance = FormValidationViewAppearance
    
    public typealias Body = any View
    
    public var isRequired: Bool

    public let content: some View
    
    public var appearance: Appearance
    
}

public struct DefaultFormValidationStyle : FormValidationStyle {
    
    /// Creates a plain button style.
    public init() { }

    /// Creates a view that represents the body of a form validation view.
    ///
    /// The system calls this method for each ``FormValidationView`` instance in a view
    /// hierarchy where this style is the current button style.
    ///
    /// - Parameter configuration : The properties of the button.
    public func makeBody(configuration: DefaultFormValidationStyle.Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if configuration.isRequired {
                    (Text(configuration.content.header)
                        .font(configuration.appearance.titleHeaderFont)
                        .foregroundColor(configuration.content.focused ? configuration.appearance.activeTitleHeaderColor : configuration.appearance.inactiveTitleHeaderColor)
                     +
                     Text(configuration.requireSymbol)
                        .font(configuration.appearance.titleHeaderFont)
                        .foregroundColor(configuration.requireFontColor))
                    .animation(.easeInOut(duration: 0.5), value: configuration.content.focused)
                } else {
                    Text(configuration.content.header)
                        .font(configuration.appearance.titleHeaderFont)
                        .foregroundColor(configuration.content.focused ? configuration.appearance.activeTitleHeaderColor : configuration.appearance.inactiveTitleHeaderColor)
                        .animation(.easeInOut(duration: 0.5), value: configuration.content.focused)
                }
            }.accessibilityAddTraits([.isHeader])
            AnyView(configuration.content)
                .padding(.vertical, 3)
            HStack {
                switch configuration.content.validationResult {
                case .valid:
                    Text(configuration.content.leftFooterMessage)
                        .font(configuration.appearance.validatedDescriptionFont)
                        .foregroundColor(configuration.appearance.formValidationColor(focused: configuration.content.focused, validationResult: configuration.content.validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: configuration.content.validationResult)
                        .accessibilityHidden(configuration.content.leftFooterMessage.isEmpty)
                case .info(let message), .warning(let message), .error(let message):
                    Text(message)
                        .font(configuration.appearance.validatedDescriptionFont)
                        .foregroundColor(configuration.appearance.formValidationColor(focused: configuration.content.focused, validationResult: configuration.content.validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: configuration.content.validationResult)
                }
                Spacer()
                if !configuration.content.rightFooterMessage.isEmpty {
                    Text(configuration.content.rightFooterMessage)
                        .font(configuration.appearance.validatedDescriptionFont)
                        .foregroundColor(configuration.appearance.formValidationColor(focused: configuration.content.focused, validationResult: configuration.content.validationResult))
                        .frame(minHeight: 15)
                        .animation(.easeInOut(duration: 0.5), value: configuration.content.validationResult)
                }
            }
        }.accessibilityElement(children: .contain)
    }
}
