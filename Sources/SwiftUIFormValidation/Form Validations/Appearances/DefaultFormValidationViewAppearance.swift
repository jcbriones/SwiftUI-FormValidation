//
//  DefaultFormValidationViewAppearance.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

public struct DefaultFormValidationViewAppearance: FormValidationViewAppearance {
    public let accentBackgroundColor: Color = .accentColor

    public let enabledBackgroundColor: Color = .white

    public let disabledBackgroundColor: Color = .gray.opacity(0.5)

    public let activeTitleHeaderColor: Color = .accentColor

    public let inactiveTitleHeaderColor: Color = .primary

    public let activeBorderColor: Color = .accentColor

    public let inactiveBorderColor: Color = .gray

    public let disabledBorderColor: Color = .gray

    public let infoBorderColor: Color = .blue

    public let warningBorderColor: Color = .yellow

    public let errorBorderColor: Color = .red

    public let validDescriptionTextColor: Color = .gray

    public let infoDescriptionTextColor: Color = .blue

    public let warningDescriptionTextColor: Color = .yellow

    public let errorDescriptionTextColor: Color = .red

    public let activeTextColor: Color = .primary

    public let inactiveTextColor: Color = .primary

    public let disabledTextColor: Color = .gray

    public let placeholderTextColor: Color = .gray

    public let requiredFieldSymbolTextColor: Color = .red

    public let imageIconColor: Color = .gray.opacity(0.8)

    public let animation: Animation = .default

    public func formValidationBorderColor(
        focused: Bool = false,
        validationResult: FormValidationResult = .valid
    ) -> Color {
        switch validationResult {
        case .valid:
            return focused ? activeBorderColor : inactiveBorderColor
        case .info:
            return infoBorderColor
        case .warning:
            return warningBorderColor
        case .error:
            return errorBorderColor
        }
    }

    public func formValidationDescriptionTextColor(validationResult: FormValidationResult = .valid) -> Color {
        switch validationResult {
        case .valid:
            return validDescriptionTextColor
        case .info:
            return infoDescriptionTextColor
        case .warning:
            return warningDescriptionTextColor
        case .error:
            return errorDescriptionTextColor
        }
    }

    public func formTextColor(focused: Bool = false, isEnabled: Bool = true) -> Color {
        focused ? activeTextColor : isEnabled ? inactiveTextColor : disabledTextColor
    }

    public let titleHeaderFont: Font = .headline

    public let textFieldFont: Font = .body

    public let validatedDescriptionFont: Font = .callout

    public init() { }
}

public extension FormValidationViewAppearance where Self == DefaultFormValidationViewAppearance {

    /// The default style for the form view.
    static var `default`: DefaultFormValidationViewAppearance {
        DefaultFormValidationViewAppearance()
    }
}
