//
//  RegexMatchValidator.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/27/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import Foundation

public struct RegexMatchValidator: FormValidator {
    // MARK: - Properties

    public var regexString: String

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
        guard let value = value as? String else { return .valid }
        if value.range(of: regexString, options: .regularExpression) != nil || value.count == 0 {
            return .valid
        } else {
            return .error(message: .Validator.isNotAValidInput(value))
        }
    }
}

public extension FormValidator where Self == RegexMatchValidator {
    static func regexMatch(_ regexString: String) -> FormValidator {
        RegexMatchValidator(regexString: regexString)
    }
}
