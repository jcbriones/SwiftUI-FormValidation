import Foundation
import SwiftUI

public enum FormValidationLocalization {
    private struct Configuration {
        var bundle: Bundle
        var tableName: String
        var localizer: any FormValidationLocalizer
    }

    private final class ConfigurationStorage: @unchecked Sendable {
        var configuration = Configuration(
            bundle: .module,
            tableName: "Validator",
            localizer: DefaultFormValidationLocalizer()
        )
    }

    private static let lock = NSLock()
    private static let storage = ConfigurationStorage()

    public static var current: any FormValidationLocalizer {
        lock.lock()
        defer { lock.unlock() }
        return storage.configuration.localizer
    }

    public static var bundle: Bundle {
        lock.lock()
        defer { lock.unlock() }
        return storage.configuration.bundle
    }

    public static var tableName: String {
        lock.lock()
        defer { lock.unlock() }
        return storage.configuration.tableName
    }

    public static func setLocalizer(_ localizer: any FormValidationLocalizer) {
        lock.lock()
        storage.configuration.localizer = localizer
        lock.unlock()
    }

    public static func configure(bundle: Bundle, tableName: String = "Validator") {
        lock.lock()
        storage.configuration.bundle = bundle
        storage.configuration.tableName = tableName
        storage.configuration.localizer = DefaultFormValidationLocalizer(bundle: bundle, tableName: tableName)
        lock.unlock()
    }

    public static func configure(tableName: String = "Validator") {
        configure(bundle: .module, tableName: tableName)
    }

    public static func reset() {
        configure(tableName: "Validator")
    }
}

enum FormValidationMessage {
    static func resource(for key: String) -> LocalizedStringResource {
        let message = FormValidationLocalization.current.string(for: key)
        return LocalizedStringResource(String.LocalizationValue(message))
    }

    static func resource(for key: String, _ arguments: CVarArg...) -> LocalizedStringResource {
        let message = FormValidationLocalization.current.string(for: key, arguments: arguments)
        return LocalizedStringResource(String.LocalizationValue(message))
    }
}
