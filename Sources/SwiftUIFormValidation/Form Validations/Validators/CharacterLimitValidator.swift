//
//  CharacterLimitValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Combine
import Foundation

public class CharacterLimitValidator: FormValidator {

    // MARK: - Initializer

    init(characterLimit: Int) {
        self.characterLimit = characterLimit
    }

    // MARK: - Properties

    var characterLimit: Int

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable) -> AnyPublisher<FormValidationResult, Never> {
        guard let value = value as? String else { return Just(.valid).eraseToAnyPublisher() }
        if value.count > characterLimit {
            return Just(
                .error(
                    message: "xloc.validator.characterLimit \(value.count.formatted()) \(characterLimit.formatted())"
                )
            ).eraseToAnyPublisher()
        } else {
            return Just(.valid).eraseToAnyPublisher()
        }
    }
}

public extension FormValidator where Self == CharacterLimitValidator {
    static func characterLimit(characterLimit: Int) -> FormValidator {
        CharacterLimitValidator(characterLimit: characterLimit)
    }
}
