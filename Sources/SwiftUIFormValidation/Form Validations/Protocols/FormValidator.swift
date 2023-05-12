//
//  FormValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Combine
import Foundation

public protocol FormValidator: AnyObject {

    /// Allows to validate a value passed in the form field and receives a validation
    /// result of one the cases: `valid`, `info`, `warning` or `error`.
    /// - Parameter value: A value that conforms to any `Equatable` object that will be used to validate.
    /// - Returns: The validation result.
    func validate(_ value: any Equatable) -> AnyPublisher<FormValidationResult, Never>
}

public extension Array where Element == any FormValidator {
    /// Allows to validate multiple form validators from the value passed in the form field and
    /// receives a validation result of one the cases: `valid`, `info`, `warning` or `error`.
    /// - Parameter value: A value that conforms to any `Equatable` object that will be used to validate.
    /// - Returns: The first non-valid validation result. If there are no non-valid result, valid will be returned.
    func validate(_ value: any Equatable) -> AnyPublisher<[FormValidationResult], Never> {
        let validators = self.map { validator in
            validator.validate(value)
        }
        return Publishers.MergeMany(validators).collect().eraseToAnyPublisher()
    }
}
