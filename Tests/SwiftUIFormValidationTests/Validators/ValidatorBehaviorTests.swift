import Foundation
import SwiftUI
import Testing
@testable import SwiftUIFormValidation

@Suite("Validator Behavior")
struct ValidatorBehaviorTests {
    @Test("RequiredFieldValidator returns error for empty string", .tags(.FormValidation.unit, .FormValidation.validator))
    func requiredFieldValidatorFailsOnEmpty() async throws {
        // Arrange: create a required field validator.
        let validator = RequiredFieldValidator(fieldName: "Email")

        // Act: validate an empty value.
        let result = try await validator.validate("")

        // Assert: verify the result is an error.
        if case let .error(message) = result {
            #expect(String(localized: message).contains("Email"))
        } else {
            Issue.record("Expected an error result")
        }
    }

    @Test("CharacterLimitValidator rejects values over limit", .tags(.FormValidation.unit, .FormValidation.validator))
    func characterLimitValidatorRejectsOverLimit() async throws {
        // Arrange: create a strict character limit validator.
        let validator = CharacterLimitValidator(characterLimit: 3)

        // Act: validate a value exceeding the configured limit.
        let result = try await validator.validate("abcd")

        // Assert: verify the validator returns an error.
        if case .error = result {
            #expect(true)
        } else {
            Issue.record("Expected an error result")
        }
    }

    @Test("EmailAddressValidator accepts valid email", .tags(.FormValidation.unit, .FormValidation.validator))
    func emailAddressValidatorAcceptsValidEmail() async throws {
        // Arrange: create email validator.
        let validator = EmailAddressValidator()

        // Act: validate a well-formed email address.
        let result = try await validator.validate("test@example.com")

        // Assert: verify validation succeeds.
        #expect(result == .valid)
    }

    @Test("EmailAddressValidator rejects invalid email and accepts empty/non-string", .tags(.FormValidation.unit, .FormValidation.validator))
    func emailAddressValidatorMixedCases() async throws {
        // Arrange: create email validator.
        let validator = EmailAddressValidator()

        // Act: evaluate invalid, empty, and non-string input values.
        let invalid = try await validator.validate("not-an-email")
        let empty = try await validator.validate("")
        let nonString = try await validator.validate(123)

        // Assert: verify result semantics for each branch.
        if case .error = invalid {
            #expect(true)
        } else {
            Issue.record("Expected invalid email to return error")
        }
        #expect(empty == .valid)
        #expect(nonString == .valid)
    }

    @Test("RegexMatchValidator fails for non matching input", .tags(.FormValidation.unit, .FormValidation.validator))
    func regexMatchValidatorFailsForNonMatch() async throws {
        // Arrange: create a validator requiring only letters.
        let validator = RegexMatchValidator(regexString: "^[a-zA-Z]+$")

        // Act: validate a value that contains digits.
        let result = try await validator.validate("abc123")

        // Assert: verify the invalid input is rejected.
        if case .error = result {
            #expect(true)
        } else {
            Issue.record("Expected an error result")
        }
    }

    @Test("MinMaxValidator returns warning and error boundaries", .tags(.FormValidation.integration, .FormValidation.validator))
    func minMaxValidatorEmitsExpectedLevels() async throws {
        // Arrange: create warning+error validator using public factory API.
        let validator = MinMaxValidator<Int>(minWarning: 5, maxWarning: 10, minError: 2, maxError: 12)

        // Act: validate values for warning and error paths.
        let warningResult = try await validator.validate(4)
        let errorResult = try await validator.validate(13)

        // Assert: verify severity levels map correctly.
        if case .warning = warningResult {
            #expect(true)
        } else {
            Issue.record("Expected a warning result")
        }
        if case .error = errorResult {
            #expect(true)
        } else {
            Issue.record("Expected an error result")
        }
    }

    @Test("FormValidator array validate preserves element count", .tags(.FormValidation.integration, .FormValidation.validator))
    func validatorArrayValidateRunsAllValidators() async throws {
        // Arrange: build an array with two validators.
        let validators: [any FormValidator] = [RequiredFieldValidator(fieldName: "Email"), CharacterLimitValidator(characterLimit: 100)]

        // Act: run aggregate validation for a valid input.
        let results = try await validators.validate("hello@world.com")

        // Assert: verify each validator produced a result.
        #expect(results.count == 2)
        #expect(results.allSatisfy { $0 == .valid })
    }

    @Test("Required and regex validators cover non-error branches", .tags(.FormValidation.unit, .FormValidation.validator))
    func requiredAndRegexValidatorsCoverNonErrorBranches() async throws {
        // Arrange: create required and regex validators.
        let required = RequiredFieldValidator(fieldName: "Items")
        let regex = RegexMatchValidator(regexString: "^[a-z]+$")

        // Act: validate representative non-error values.
        let requiredArrayValid = try await required.validate([1, 2, 3])
        let regexValid = try await regex.validate("abc")
        let regexEmpty = try await regex.validate("")

        // Assert: verify expected valid outcomes.
        #expect(requiredArrayValid == .valid)
        #expect(regexValid == .valid)
        #expect(regexEmpty == .valid)
    }

    @Test("MinMaxValidator warning-only and error-only ranges", .tags(.FormValidation.integration, .FormValidation.validator))
    func minMaxValidatorWarningOnlyAndErrorOnlyRanges() async throws {
        // Arrange: create two validators for warning-only and error-only behavior.
        let warningOnly = MinMaxValidator<Int>(minWarning: 5, maxWarning: 10)
        let errorOnly = MinMaxValidator<Int>(minError: 5, maxError: 10)

        // Act: evaluate values around both boundaries.
        let warningLow = try await warningOnly.validate(4)
        let warningHigh = try await warningOnly.validate(11)
        let warningValid = try await warningOnly.validate(7)

        let errorLow = try await errorOnly.validate(4)
        let errorHigh = try await errorOnly.validate(11)
        let errorValid = try await errorOnly.validate(7)
        let nonNumber = try await warningOnly.validate("not-a-number")

        // Assert: verify each branch returns expected severity.
        if case .warning = warningLow {
            #expect(true)
        } else {
            Issue.record("Expected low warning")
        }
        if case .warning = warningHigh {
            #expect(true)
        } else {
            Issue.record("Expected high warning")
        }
        #expect(warningValid == .valid)

        if case .error = errorLow {
            #expect(true)
        } else {
            Issue.record("Expected low error")
        }
        if case .error = errorHigh {
            #expect(true)
        } else {
            Issue.record("Expected high error")
        }
        #expect(errorValid == .valid)
        #expect(nonNumber == .valid)
    }

    @Test("FormValidationResult validity semantics", .tags(.FormValidation.unit))
    @MainActor
    func formValidationResultValiditySemantics() {
        // Arrange: prepare representative result values.
        let info = FormValidationResult.info(message: "Info")
        let warning = FormValidationResult.warning(message: "Warning")
        let error = FormValidationResult.error(message: "Error")

        // Act: read the `isValid` semantics.
        let infoValid = info.isValid
        let warningValid = warning.isValid
        let errorValid = error.isValid

        // Assert: verify valid-like and invalid-like states.
        #expect(infoValid)
        #expect(warningValid)
        #expect(!errorValid)
    }
}
