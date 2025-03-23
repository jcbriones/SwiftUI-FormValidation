//
//  RequiredFieldValidator.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation

public struct RequiredFieldValidator: FormValidator {
    // MARK: - Properties

    public var fieldName: String

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable) -> FormValidationResult {
        if let value = value as? String?, (value ?? "").count == 0 {
            return .error(message: "xloc.validator.isRequired \(fieldName)")
        }
        if let value = value as? [Any], value.count == 0 {
            return .error(message: "xloc.validator.isRequired \(fieldName)")
        }
        return .valid
    }
}

public extension FormValidator where Self == RequiredFieldValidator {
    static func requiredField(fieldName: String) -> FormValidator {
        RequiredFieldValidator(fieldName: fieldName)
    }
}
