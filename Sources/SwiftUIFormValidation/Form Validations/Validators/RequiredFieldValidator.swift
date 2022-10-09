//
//  RequiredFieldValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation

public class RequiredFieldValidator: FormValidator {

    // MARK: - Initializer

    init(fieldName: String) {
        self.fieldName = fieldName
    }

    // MARK: - Properties

    var fieldName: String

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable) -> FormValidationResult {
        if let value = value as? String?, (value ?? "").count == 0 {
            return .error(message: "\(fieldName) is required.")
        }
        if let value = value as? [Any], value.count == 0 {
            return .error(message: "\(fieldName) is required.")
        }
        return .valid
    }
}

public extension FormValidator where Self == RequiredFieldValidator {
    static func requiredField(fieldName: String) -> FormValidator {
        RequiredFieldValidator(fieldName: fieldName)
    }
}
