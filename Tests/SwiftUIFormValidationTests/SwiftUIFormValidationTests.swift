import XCTest
@testable import SwiftUIFormValidation

final class SwiftUIFormValidationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        FormValidationLocalization.reset()
    }

    override func tearDown() {
        FormValidationLocalization.reset()
        super.tearDown()
    }

    func testDefaultLocalizerResolvesFromModuleValidatorTable() {
        let message = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.characterLimitReached)
        XCTAssertEqual(message, "Character limit reached.")
    }

    func testDefaultLocalizerResolvesFormattedStrings() {
        let message = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.isRequired, "Email")
        XCTAssertEqual(message, "Email is required.")
    }

    func testMissingKeyFallsBackToReadableKey() {
        let missingKey = "validator.missing.key"
        let message = FormValidationLocalization.current.string(for: missingKey)
        XCTAssertEqual(message, missingKey)
    }

    @MainActor
    func testCustomLocalizerOverrideIsRespectedByValidators() async throws {
        FormValidationLocalization.setLocalizer(MockLocalizer())

        let validator = RequiredFieldValidator(fieldName: "Email")
        let result = try await validator.validate("")

        guard case let .error(message) = result else {
            return XCTFail("Expected validation to fail")
        }

        XCTAssertEqual(String(localized: message), "mock::isRequired %@::Email")
    }

    func testResetRestoresDefaultBetweenTests() {
        FormValidationLocalization.setLocalizer(MockLocalizer())
        FormValidationLocalization.reset()

        let message = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.required)
        XCTAssertEqual(message, "(Field Required)")
    }

    func testConfigureRestoresDefaultLocalizerWithProvidedSettings() {
        FormValidationLocalization.setLocalizer(MockLocalizer())
        FormValidationLocalization.configure(bundle: .module, tableName: "Validator")

        XCTAssertEqual(FormValidationLocalization.tableName, "Validator")
        let message = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.required)
        XCTAssertEqual(message, "(Field Required)")
    }
}

private struct MockLocalizer: FormValidationLocalizer {
    func string(for key: String) -> String {
        "mock::\(key)"
    }

    func string(for key: String, arguments: [CVarArg]) -> String {
        guard !arguments.isEmpty else {
            return string(for: key)
        }

        let joinedArgs = arguments.map { String(describing: $0) }.joined(separator: ",")
        return "mock::\(key)::\(joinedArgs)"
    }
}
