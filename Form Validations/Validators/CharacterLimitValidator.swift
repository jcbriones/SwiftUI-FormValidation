//
//  CharacterLimitValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation

class CharacterLimitValidator: FormValidator {

    // MARK: - Initializer

    init(characterLimit: Int) {
        self.characterLimit = characterLimit
    }

    // MARK: - Properties

    var characterLimit: Int

    // MARK: - FormValidator Protocol

    func validate(_ value: any Equatable) -> FormValidationResult {
        guard let value = value as? String else { return .valid }
        if value.count > characterLimit {
            return .error(message: "Character Limit: \(value.count) / \(characterLimit)")
        } else {
            return .valid
        }
    }
}
