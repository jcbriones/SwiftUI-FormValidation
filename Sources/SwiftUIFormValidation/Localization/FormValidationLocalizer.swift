import Foundation

public protocol FormValidationLocalizer: Sendable {
    func string(for key: String) -> String
    func string(for key: String, arguments: [CVarArg]) -> String
}

public extension FormValidationLocalizer {
    func string(for key: String, _ args: CVarArg...) -> String {
        string(for: key, arguments: args)
    }
}

public struct DefaultFormValidationLocalizer: FormValidationLocalizer, Sendable {
    public let bundle: Bundle
    public let tableName: String

    public init(bundle: Bundle, tableName: String = "Validator") {
        self.bundle = bundle
        self.tableName = tableName
    }

    public init(tableName: String = "Validator") {
        self.init(bundle: .module, tableName: tableName)
    }

    public func string(for key: String) -> String {
        let value = String(
            localized: String.LocalizationValue(key),
            table: tableName,
            bundle: bundle,
            comment: ""
        )
        return value.isEmpty ? key : value
    }

    public func string(for key: String, arguments: [CVarArg]) -> String {
        guard !arguments.isEmpty else {
            return string(for: key)
        }

        let format = string(for: key)
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}
