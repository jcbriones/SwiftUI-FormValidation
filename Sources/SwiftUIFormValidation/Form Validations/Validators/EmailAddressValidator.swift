//
//  EmailAddressValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Combine
import Foundation

public class EmailAddressValidator: FormValidator {

    // MARK: - Initializer

    init() { }

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable) -> AnyPublisher<FormValidationResult, Never> {
        guard let value = value as? String else { return Just(.valid).eraseToAnyPublisher() }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        // let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: value) {
            return Just(.valid).eraseToAnyPublisher()
        } else {
            return Just(.error(message: "xloc.validator.isNotAValidEmailAddress \(value)")).eraseToAnyPublisher()
        }
    }
}

public extension FormValidator where Self == EmailAddressValidator {
    static func emailAddress() -> FormValidator {
        EmailAddressValidator()
    }
}
