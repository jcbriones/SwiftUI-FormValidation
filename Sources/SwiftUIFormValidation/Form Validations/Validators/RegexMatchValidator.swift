//
//  RegexMatchValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 3/27/23.
//  Copyright © 2023 Recomdy, LLC. All rights reserved.
//

import Combine
import Foundation

public class RegexMatchValidator: FormValidator {

    // MARK: - Initializer

    init(_ regexString: String) {
        self.regexString = regexString
    }

    // MARK: - Properties

    var regexString: String

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable) -> AnyPublisher<FormValidationResult, Never> {
        guard let value = value as? String else { return Just(.valid).eraseToAnyPublisher() }
        if value.range(of: regexString, options: .regularExpression) != nil || value.count == 0 {
            return Just(.valid).eraseToAnyPublisher()
        } else {
            return Just(.error(message: "xloc.validator.isNotAValidInput \(value)")).eraseToAnyPublisher()
        }
    }
}

public extension FormValidator where Self == RegexMatchValidator {
    static func regexMatch(_ regexString: String) -> FormValidator {
        RegexMatchValidator(regexString)
    }
}
