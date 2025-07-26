# SwiftUI Form Validation

A comprehensive, pure SwiftUI form validation library that provides reusable form components with built-in validation capabilities.

## Features

- ✅ Pure SwiftUI implementation
- ✅ Async validation support
- ✅ Built-in validators (email, character limit, required fields, etc.)
- ✅ Custom validator support
- ✅ Real-time validation feedback
- ✅ Accessibility support
- ✅ Customizable appearance
- ✅ Localization support

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/jcbriones/SwiftUIFormValidation.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version/branch you want to use

## Quick Start

```swift
import SwiftUI
import SwiftUIFormValidation

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            FormTextField(
                $email,
                header: "Email Address",
                placeholder: "Enter your email"
            )
            .formValidation(
                .emailAddress(),
                .requiredField(fieldName: "Email")
            )
            
            FormTextField(
                $password,
                header: "Password", 
                placeholder: "Enter your password"
            )
            .formValidation(
                .requiredField(fieldName: "Password"),
                .characterLimit(characterLimit: 50)
            )
        }
        .padding()
    }
}
```

## Built-in Form Components

### FormTextField

A text input field with validation support.

```swift
FormTextField(
    $textValue,
    header: "Field Name",
    imageName: "person", // Optional: Custom image
    systemName: "envelope", // Optional: SF Symbol
    placeholder: "Enter text here"
)
```

**Parameters:**
- `value`: Binding to `String` or `String?`
- `header`: Optional localized string key for the field label
- `imageName`: Optional custom image name to display as an icon
- `systemName`: Optional SF Symbol name to display as an icon
- `placeholder`: Placeholder text when field is empty

### FormItemPicker

A picker component for selecting from a collection of items.

```swift
struct Country: AnyItem {
    let id = UUID()
    var localizedString: LocalizedStringResource { LocalizedStringResource(name) }
    let name: String
}

let countries = [
    Country(name: "United States"),
    Country(name: "Canada"),
    Country(name: "Mexico")
]

FormItemPicker(
    $selectedCountry,
    header: "Country",
    placeholder: "Select a country",
    collection: countries
)
```

**Requirements:**
- Items must conform to `AnyItem` protocol
- Items must have a unique `id` property
- Items must provide a `localizedString` for display

## Built-in Validators

### Required Field Validator

Ensures a field has a value.

```swift
.formValidation(.requiredField(fieldName: "Email"))
```

### Email Address Validator

Validates email format using a comprehensive regex pattern.

```swift
.formValidation(.emailAddress())
```

### Character Limit Validator

Limits the number of characters in a text field.

```swift
.formValidation(.characterLimit(characterLimit: 100))
```

### Min/Max Validator

Validates numeric values within specified ranges with support for both warnings and errors.

```swift
// Warning range only
.formValidation(.minMaxValidator(minWarning: 10, maxWarning: 90))

// Error range only  
.formValidation(.minMaxValidator(minError: 0, maxError: 100))

// Both warning and error ranges
.formValidation(.minMaxValidator(
    minWarning: 20, maxWarning: 80,
    minError: 0, maxError: 100
))
```

### Regex Match Validator

Validates input against a custom regular expression.

```swift
.formValidation(.regexMatch("^[A-Za-z]+$")) // Letters only
```

## Validation Results

The validation system supports four types of results:

- `.valid`: Field passes all validation
- `.info(message:)`: Informational message
- `.warning(message:)`: Warning that doesn't prevent submission
- `.error(message:)`: Error that should prevent submission

## Creating Custom Validators

Implement the `FormValidator` protocol to create custom validators:

```swift
public struct CustomValidator: FormValidator {
    public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
        guard let stringValue = value as? String else { return .valid }
        
        // Your validation logic here
        if stringValue.contains("forbidden") {
            return .error(message: "This word is not allowed")
        }
        
        return .valid
    }
}

// Extend FormValidator for convenience
public extension FormValidator where Self == CustomValidator {
    static func custom() -> FormValidator {
        CustomValidator()
    }
}

// Usage
FormTextField($text, header: "Input")
    .formValidation(.custom())
```

## Creating Custom Form Components

Implement the `FormValidationContent` protocol to create custom form components:

```swift
public struct CustomFormField: FormValidationContent {
    @Binding public var value: String
    public var model: FormModel<String>
    
    public var body: some View {
        // Your custom UI implementation
        Text("Custom Field: \(value)")
            .modifier(FormFieldContentModifier($value, model: model))
    }
    
    public init(_ value: Binding<String>, header: LocalizedStringResource? = nil) {
        self._value = value
        self.model = .init(header: header)
    }
}
```

## Customizing Appearance

You can customize the appearance of form components using the form appearance environment:

```swift
VStack {
    // Your form fields here
}
.formAppearance(
    FormValidationViewAppearance(
        borderRadius: 8,
        borderWidthActive: 2,
        borderWidthInactive: 1,
        activeBorderColor: .blue,
        inactiveBorderColor: .gray,
        // ... other appearance properties
    )
)
```

## Multiple Validators

Chain multiple validators on a single field:

```swift
FormTextField($email, header: "Email")
    .formValidation(
        .requiredField(fieldName: "Email"),
        .emailAddress(),
        .characterLimit(characterLimit: 100)
    )
```

Validation stops at the first validator that returns a non-valid result.

## External Validation

You can trigger validation from outside the form component:

```swift
struct MyForm: View {
    @State private var externalValidationTrigger = PassthroughSubject<Void, Never>()
    
    var body: some View {
        VStack {
            FormTextField($email, header: "Email")
                .formValidation(.emailAddress())
            
            Button("Validate All") {
                externalValidationTrigger.send()
            }
        }
        .environment(\.externalValidator, externalValidationTrigger.eraseToAnyPublisher())
    }
}
```

## Localization

The library supports localization through `LocalizedStringResource`. Built-in validation messages use keys like:

- `LocalizedStringResource.Validator.characterLimitReached`
- `LocalizedStringResource.Validator.isNotAValidEmailAddress`
- `LocalizedStringResource.Validator.isRequired`
- `LocalizedStringResource.Validator.required`

Copy the existing `Validator.xcstrings` file in your app to customize these messages:

## Accessibility

The library includes built-in accessibility support:

- Form headers are marked with `.isHeader` trait
- Required field indicators are properly labeled
- Validation messages are announced to screen readers
- Form fields are grouped as accessibility containers

## Best Practices

### 1. Organize Validators

Group related validators together and consider creating custom validators for complex business logic:

```swift
extension FormValidator {
    static func userRegistration() -> [FormValidator] {
        [
            .requiredField(fieldName: "Username"),
            .characterLimit(characterLimit: 30),
            .regexMatch("^[a-zA-Z0-9_]+$")
        ]
    }
}
```

### 2. Handle Async Validation

For validators that need to make network calls:

```swift
public struct UniqueUsernameValidator: FormValidator {
    public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
        guard let username = value as? String, !username.isEmpty else { return .valid }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if username == "admin" {
            return .error(message: "Username is already taken")
        }
        
        return .valid
    }
}
```

### 3. Performance Considerations

- Validators run on every value change
- Consider debouncing expensive validations
- Use appropriate validation triggers (onChange vs onSubmit)

### 4. Error Handling

Always handle potential errors in custom validators:

```swift
public func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult {
    do {
        // Validation logic that might throw
        return .valid
    } catch {
        return .error(message: "Validation failed: \(error.localizedDescription)")
    }
}
```

## API Reference

### Protocols

#### FormValidator
```swift
public protocol FormValidator {
    func validate(_ value: any Equatable & Sendable) async throws -> FormValidationResult
}
```

#### FormValidationContent
```swift
public protocol FormValidationContent: View {
    associatedtype Value: Equatable & Sendable
    var value: Value { get set }
    var model: FormModel<Value> { get }
}
```

#### AnyItem
```swift
public protocol AnyItem: Identifiable, Equatable {
    var localizedString: LocalizedStringResource { get }
}
```

### Environment Values

- `\.formAppearance`: Customize visual appearance
- `\.formValidationResult`: Current validation state
- `\.externalValidator`: Trigger external validation
- `\.externalValidationResult`: External validation result

## Dependencies

This package depends on:
- [SwiftUI-Flow](https://github.com/tevelee/SwiftUI-Flow.git) (3.0.2+)

## Requirements

- iOS 16.0+
- macOS 13.0+
- tvOS 16.0+
- Swift 6.0+

## License

Copyright © 2022-2025 PetCollab, LLC. All rights reserved.

## Contributing

When contributing to this repository, please:

1. Ensure all public APIs are properly documented
2. Add unit tests for new validators
3. Follow the existing code style and conventions
4. Update this documentation for any new features

## Support

For issues, feature requests, or questions, please create an issue in the GitHub repository.
