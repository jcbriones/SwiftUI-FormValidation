//
//  FormValidationViewAppearance.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

public struct FormValidationViewAppearance: FormValidationViewAppearanceProtocol {
    public var enabledBackgroundColor: Color { .white }
    
    public var disabledBackgroundColor: Color { .gray.opacity(0.5) }
    
    public var activeTitleHeaderColor: Color { .accentColor }
    
    public var inactiveTitleHeaderColor: Color { .primary }
    
    public var activeBorderColor: Color { .accentColor }
    
    public var inactiveBorderColor: Color { .gray }
    
    public var disabledBorderColor: Color { .gray }
    
    public var validBorderColor: Color { .gray }
    
    public var infoBorderColor: Color { .blue }
    
    public var warningBorderColor: Color { .yellow }
    
    public var errorBorderColor: Color { .red }
    
    public var infoDescriptionTextColor: Color { .blue }
    
    public var warningDescriptionTextColor: Color { .yellow }
    
    public var errorDescriptionTextColor: Color { .red }
    
    public var activeTextColor: Color { .primary }
    
    public var inactiveTextColor: Color { .primary }
    
    public var disabledTextColor: Color { .gray }
    
    public var placeholderTextColor: Color { .gray }
    
    public var requiredFieldSymbolTextColor: Color { .red }
    
    public var imageIconColor: Color { .gray.opacity(0.8) }
    
    public func validatedBorderColor(_ result: FormValidationResult) -> Color {
        switch result {
        case .valid:
            return validBorderColor
        case .info:
            return infoBorderColor
        case .warning:
            return warningBorderColor
        case .error:
            return errorBorderColor
        }
    }
    
    public func formValidationColor(focused: Bool = false, validationResult: FormValidationResult = .valid) -> Color {
        validationResult != .valid ? validatedBorderColor(validationResult) : (focused ? activeBorderColor : inactiveBorderColor)
    }
    public func formTextColor(focused: Bool = false, isEnabled: Bool = true) -> Color {
        focused ? activeTextColor : isEnabled ? inactiveTextColor : disabledTextColor
    }
    
    public var titleHeaderFont: Font { .headline }
    
    public var textFieldFont: Font { .body }
    
    public var validatedDescriptionFont: Font { .callout }

}
