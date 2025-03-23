//
//  FormValidationContent+Extensions.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/23/25.
//

import SwiftUI

public extension FormValidationContent {
    /// Adds a footer message below the form field view
    /// - Parameter footerMessage: An optional string which is displayed at the bottom of the form validation field.
    /// - Returns: A modified view with footer message added to it.
    func footerMessage(_ footerMessage: LocalizedStringKey) -> Self {
        var copy = self
        copy.model.footer = footerMessage
        return copy
    }

    /// Adds a footer message below the form field view
    /// - Parameter footerMessage: An optional string which is displayed at the bottom of the form validation field.
    /// - Returns: A modified view with footer message added to it.
    func footerMessage(_ footerMessage: String) -> Self {
        var copy = self
        copy.model.footer = .init(footerMessage)
        return copy
    }

    /// Makes the form field a required field
    /// - Returns: A modified view with setting the field as required.
    /// - Parameters:
    ///   - isRequired: If the validation field is required.
    ///   - customName: An optional value to change the name of the field in the error message when field is blank or empty.
    func isRequired(_ isRequired: Bool, customName: String? = nil) -> Self {
        var copy = self
        if isRequired, let header = copy.model.header,
           !copy.model.validators.contains(where: { $0 is RequiredFieldValidator }) {
            copy.model.validators.append(RequiredFieldValidator(fieldName: customName ?? header.stringValue()))
        } else {
            copy.model.validators.removeAll(where: { $0 is RequiredFieldValidator })
        }
        return copy
    }

    /// Adds a limit to the number of characters allowed in the form field and displays a number count as well for user reference.
    /// - Parameter maxCharCount: The maximum number of characters allowed before it throws an error validation result.
    /// - Returns: A modified view with character limit validator.
    func maxCharCount(_ maxCharCount: Int?) -> Self {
        var copy = self
        if let maxCharCount,
           !copy.model.validators.contains(where: { $0 is CharacterLimitValidator }) {
            copy.model.validators.append(CharacterLimitValidator(characterLimit: maxCharCount))
        } else {
            copy.model.validators.removeAll(where: { $0 is CharacterLimitValidator })
        }
        return copy
    }

    /// Adds a set of validators to the form field.
    /// - Parameters:
    ///   - validators: Validators to be applied on this field.
    ///   - delay: A delay when to trigger validations.
    /// - Returns: A modified view with set of validators
    func validators(_ validators: [any FormValidator], delay: RunLoop.SchedulerTimeType.Stride = .zero) -> Self {
        var copy = self
        copy.model.validators = validators
        return copy
    }
}
