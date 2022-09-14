//
//  MinMaxValidator.swift
//  Recomdy
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation

class MinMaxValidator<Number>: FormValidator where Number: Numeric & Comparable {

    // MARK: - Initializer

    convenience init(minWarning: Number, maxWarning: Number) {
        guard minWarning < maxWarning else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(minWarning, maxWarning, nil, nil)
    }
    convenience init(minError: Number, maxError: Number) {
        guard minError < maxError else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(nil, nil, minError, maxError)
    }
    convenience init(minWarning: Number, maxWarning: Number, minError: Number, maxError: Number) {
        guard minWarning >= minError && maxWarning <= maxError && minWarning <= maxWarning else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(minWarning, maxWarning, minError, maxError)
    }
    private init(_ minWarning: Number? = nil, _ maxWarning: Number? = nil, _ minError: Number? = nil, _ maxError: Number? = nil) {
        self.minWarning = minWarning
        self.maxWarning = maxWarning
        self.minError = minError
        self.maxError = maxError
    }

    // MARK: - Properties

    var minWarning: Number?
    var maxWarning: Number?
    var minError: Number?
    var maxError: Number?

    // MARK: - FormValidator Protocol

    func validate(_ value: any Equatable) -> FormValidationResult {
        guard let value = value as? Number else { return .valid }

        return .valid
    }
}
