//
//  FormValidationViewAppearance.swift
//  SwiftUIFormValidation
//
//  Enhanced appearance system with better customization
//

import SwiftUI

public protocol FormValidationViewAppearance {
    // MARK: - Colors

    // Config
    var requiredSymbol: String { get }
    // Background
    var accentBackgroundColor: Color { get }
    var enabledBackgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    // Title
    var activeTitleHeaderColor: Color { get }
    var inactiveTitleHeaderColor: Color { get }
    // Border
    var activeBorderColor: Color { get }
    var inactiveBorderColor: Color { get }
    var disabledBorderColor: Color { get }
    var infoBorderColor: Color { get }
    var warningBorderColor: Color { get }
    var errorBorderColor: Color { get }
    // Text
    var validDescriptionTextColor: Color { get }
    var infoDescriptionTextColor: Color { get }
    var warningDescriptionTextColor: Color { get }
    var errorDescriptionTextColor: Color { get }
    var activeTextColor: Color { get }
    var inactiveTextColor: Color { get }
    var disabledTextColor: Color { get }
    var placeholderTextColor: Color { get }
    var requiredFieldSymbolTextColor: Color { get }
    // Extras
    var imageIconColor: Color { get }
    var animation: Animation { get }

    // MARK: - Font Styles

    var titleHeaderFont: Font { get }
    var textFieldFont: Font { get }
    var validatedDescriptionFont: Font { get }

    // MARK: - Paddings

    var topPadding: CGFloat { get }
    var bottomPadding: CGFloat { get }
    var leadingPadding: CGFloat { get }
    var trailingPadding: CGFloat { get }

    // MARK: - Border

    var borderWidthActive: CGFloat { get }
    var borderWidthInactive: CGFloat { get }
    var borderRadius: CGFloat { get }

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
