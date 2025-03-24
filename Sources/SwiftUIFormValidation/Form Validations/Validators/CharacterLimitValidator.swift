//
//  CharacterLimitValidator.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation

public struct CharacterLimitValidator: FormValidator {
    // MARK: - Properties

    public var characterLimit: Int

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
        guard let value = value as? String else { return .valid }
        if value.count > characterLimit {
            return .error(message: "xloc.validator.characterLimitReached")
        } else {
            return .valid
        }
    }
}

public extension FormValidator where Self == CharacterLimitValidator {
    static func characterLimit(characterLimit: Int) -> FormValidator {
        CharacterLimitValidator(characterLimit: characterLimit)
    }
}
