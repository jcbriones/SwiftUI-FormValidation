//
//  MinMaxValidator.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/28/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation

public struct MinMaxValidator<Number>: FormValidator where Number: Numeric & Comparable & Sendable {

    // MARK: - Initializer

    init(minWarning: Number, maxWarning: Number) {
        guard minWarning <= maxWarning else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(minWarning, maxWarning, nil, nil)
    }
    init(minError: Number, maxError: Number) {
        guard minError <= maxError else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(nil, nil, minError, maxError)
    }
    init(minWarning: Number, maxWarning: Number, minError: Number, maxError: Number) {
        guard minWarning >= minError && maxWarning <= maxError && minWarning <= maxWarning else {
            fatalError("MinMaxValidator setup incorrectly")
        }
        self.init(minWarning, maxWarning, minError, maxError)
    }
    private init(
        _ minWarning: Number? = nil,
        _ maxWarning: Number? = nil,
        _ minError: Number? = nil,
        _ maxError: Number? = nil
    ) {
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

    public let formatter = NumberFormatter()

    // MARK: - FormValidator Protocol

    public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
        guard let value = value as? Number else { return .valid }
        return validateWarningAndError(value) ?? validateWarning(value) ?? validateError(value) ?? .valid
    }

    private func validateWarningAndError(_ value: Number) -> FormValidationResult? {
        guard let minWarning, let maxWarning, let minError, let maxError else {
            return nil
        }
        if value < minError {
            return .error(
                message: "xloc.validator.isLessThan \(formatString(value)) \(formatString(minError))"
            )
        } else if value > maxError {
            return .error(
                message: "xloc.validator.isGreaterThan \(formatString(value)) \(formatString(maxError))"
            )
        } else if value < minWarning {
            return .warning(
                message: "xloc.validator.isLessThan \(formatString(value)) \(formatString(minWarning))"
            )
        } else if value > maxWarning {
            return .warning(
                message: "xloc.validator.isGreaterThan \(formatString(value)) \(formatString(maxWarning))"
            )
        }
        return .valid
    }

    private func validateWarning(_ value: Number) -> FormValidationResult? {
        guard let minWarning, let maxWarning else {
            return nil
        }
        if value < minWarning {
            return .warning(
                message: "xloc.validator.isLessThan \(formatString(value)) \(formatString(minWarning))"
            )
        } else if value > maxWarning {
            return .warning(
                message: "xloc.validator.isGreaterThan \(formatString(value)) \(formatString(maxWarning))"
            )
        }
        return .valid
    }

    private func validateError(_ value: Number) -> FormValidationResult? {
        guard let minError, let maxError else {
            return nil
        }
        if value < minError {
            return .error(
                message: "xloc.validator.isLessThan \(formatString(value)) \(formatString(minError))"
            )
        } else if value > maxError {
            return .error(
                message: "xloc.validator.isGreaterThan \(formatString(value)) \(formatString(maxError))"
            )
        }
        return .valid
    }

    private func formatString(_ object: Any?) -> String {
        formatter.string(for: object) ?? ""
    }
}

public extension FormValidator {
    static func minMaxValidator<Number>(
        minWarning: Number,
        maxWarning: Number
    ) -> FormValidator where Self == MinMaxValidator<Number> {
        MinMaxValidator<Number>(minWarning: minWarning, maxWarning: maxWarning)
    }
    static func minMaxValidator<Number>(
        minError: Number,
        maxError: Number
    ) -> FormValidator where Self == MinMaxValidator<Number> {
        MinMaxValidator<Number>(minError: minError, maxError: maxError)
    }
    static func minMaxValidator<Number>(
        minWarning: Number,
        maxWarning: Number,
        minError: Number,
        maxError: Number
    ) -> FormValidator where Self == MinMaxValidator<Number> {
        MinMaxValidator<Number>(minWarning: minWarning, maxWarning: maxWarning, minError: minError, maxError: maxError)
    }
}
