//
//  FormValidationViewAppearance.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

public protocol FormValidationViewAppearance: Sendable {
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

    // MARK: - Font Styles

    var titleHeaderFont: Font { get }
    var textFieldFont: Font { get }
    var validatedDescriptionFont: Font { get }

    // MARK: - Views
    func row<Item>(_ items: [Item]) -> AnyView where Item: AnyItem
    func selectableRow<Item>(_ items: [Item], selected: Binding<[Item]>) -> AnyView where Item: AnySelectableItem
}

public extension FormValidationViewAppearance {
    func formValidationBorderColor(
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

    func formValidationDescriptionTextColor(
        focused: Bool = false,
        validationResult: FormValidationResult = .valid
    ) -> Color {
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

    func formTextColor(focused: Bool = false, isEnabled: Bool = true) -> Color {
        focused ? activeTextColor : isEnabled ? inactiveTextColor : disabledTextColor
    }
}
