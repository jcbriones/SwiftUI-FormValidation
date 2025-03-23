//
//  FormValidator.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation

public protocol FormValidator {

    /// Allows to validate a value passed in the form field and receives a validation
    /// result of one the cases: `valid`, `info`, `warning` or `error`.
    /// - Parameter value: A value that conforms to any `Equatable` object that will be used to validate.
    /// - Returns: The validation result.
    func validate(_ value: any Equatable) -> FormValidationResult
}

public extension Array where Element == any FormValidator {
    /// Allows to validate multiple form validators from the value passed in the form field and
    /// receives a validation result of one the cases: `valid`, `info`, `warning` or `error`.
    /// - Parameter value: A value that conforms to any `Equatable` object that will be used to validate.
    /// - Returns: The first non-valid validation result. If there are no non-valid result, valid will be returned.
    func validate(_ value: any Equatable) -> [FormValidationResult] {
        return self.map { validator in
            validator.validate(value)
        }
    }
}
