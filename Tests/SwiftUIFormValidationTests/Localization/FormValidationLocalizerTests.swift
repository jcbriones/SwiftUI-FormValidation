import Foundation
import Testing
@testable import SwiftUIFormValidation

@Suite("Form Validation Localization", .serialized)
struct FormValidationLocalizerTests {
    @Test("Default localizer resolves known key", .tags(.FormValidation.unit, .FormValidation.localization))
    func defaultLocalizerResolvesKnownKey() {
        // Arrange: create the localizer with module resources.
        let localizer = DefaultFormValidationLocalizer(bundle: .module, tableName: "Validator")

        // Act: resolve a known key.
        let message = localizer.string(for: FormValidationLocalizationKey.characterLimitReached)

        // Assert: verify localization lookup succeeds.
        #expect(message == "Character limit reached.")
    }

    @Test("Default localizer resolves formatted key", .tags(.FormValidation.unit, .FormValidation.localization))
    func defaultLocalizerResolvesFormattedKey() {
        // Arrange: create the default localizer.
        let localizer = DefaultFormValidationLocalizer(bundle: .module, tableName: "Validator")

        // Act: resolve a format key with arguments.
        let message = localizer.string(for: FormValidationLocalizationKey.isLessThan, arguments: ["1", "3"])

        // Assert: verify formatted message output.
        #expect(message == "1 is less than 3.")
    }

    @Test("Default localizer falls back to key when missing", .tags(.FormValidation.unit, .FormValidation.localization))
    func defaultLocalizerFallbackWhenMissing() {
        // Arrange: create the default localizer.
        let localizer = DefaultFormValidationLocalizer(bundle: .module, tableName: "Validator")

        // Act: resolve a key that does not exist.
        let message = localizer.string(for: "missing.localization.key")

        // Assert: verify readable fallback behavior.
        #expect(message == "missing.localization.key")
    }

    @Test("Global localization configuration can swap and reset localizer", .tags(.FormValidation.integration, .FormValidation.localization))
    func globalConfigurationCanSwapAndReset() {
        // Arrange: install a mock localizer.
        FormValidationLocalization.setLocalizer(MockLocalizer())

        // Act: read from mock, then reset to defaults.
        let overridden = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.required)
        FormValidationLocalization.reset()
        let resetValue = FormValidationLocalization.current.string(for: FormValidationLocalizationKey.required)

        // Assert: verify override and restoration both work.
        #expect(overridden == "mock::required")
        #expect(resetValue == "(Field Required)")
    }
}

private struct MockLocalizer: FormValidationLocalizer {
    func string(for key: String) -> String {
        "mock::\(key)"
    }

    func string(for key: String, arguments: [CVarArg]) -> String {
        let joined = arguments.map { String(describing: $0) }.joined(separator: ",")
        return "mock::\(key)::\(joined)"
    }
}
