//
//  FormValidationViewAppearance.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

public protocol FormValidationViewAppearance {

    // MARK: - Colors

    var accentBackgroundColor: Color { get }
    var enabledBackgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var activeTitleHeaderColor: Color { get }
    var inactiveTitleHeaderColor: Color { get }
    var activeBorderColor: Color { get }
    var inactiveBorderColor: Color { get }
    var disabledBorderColor: Color { get }
    var infoBorderColor: Color { get }
    var warningBorderColor: Color { get }
    var errorBorderColor: Color { get }
    var validDescriptionTextColor: Color { get }
    var infoDescriptionTextColor: Color { get }
    var warningDescriptionTextColor: Color { get }
    var errorDescriptionTextColor: Color { get }
    var activeTextColor: Color { get }
    var inactiveTextColor: Color { get }
    var disabledTextColor: Color { get }
    var placeholderTextColor: Color { get }
    var requiredFieldSymbolTextColor: Color { get }
    var imageIconColor: Color { get }
    var animation: Animation { get }

    func formValidationBorderColor(focused: Bool, validationResult: FormValidationResult) -> Color
    func formValidationDescriptionTextColor(validationResult: FormValidationResult) -> Color
    func formTextColor(focused: Bool, isEnabled: Bool) -> Color

    // MARK: - Font Styles

    var titleHeaderFont: Font { get }
    var textFieldFont: Font { get }
    var validatedDescriptionFont: Font { get }
}
