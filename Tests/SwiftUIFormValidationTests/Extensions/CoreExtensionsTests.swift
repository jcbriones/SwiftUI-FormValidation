import Combine
import Foundation
import SwiftUI
import Testing
@testable import SwiftUIFormValidation

@Suite("Core Extensions")
struct CoreExtensionsTests {
    @Test("FixedWidthInteger bit component helpers round-trip", .tags(.FormValidation.unit, .FormValidation.extensionMethods))
    func fixedWidthIntegerRoundTrip() {
        // Arrange: define a bitset value.
        let value: UInt8 = 0b00010101

        // Act: decompose and reconstruct the same number.
        let components = value.bitComponents
        let reconstructed = UInt8(bitComponents: components)

        // Assert: verify round-trip correctness.
        #expect(reconstructed == value)
        #expect(components == [1, 4, 16])
    }

    @Test("OptionSet components exposes selected flags", .tags(.FormValidation.unit, .FormValidation.extensionMethods))
    func optionSetComponentsExposesFlags() {
        // Arrange: create a sample option-set value.
        let value: TestFlags = [.alpha, .gamma]

        // Act: enumerate selected components.
        let parts = value.components

        // Assert: verify each selected component is present.
        #expect(parts.contains(.alpha))
        #expect(parts.contains(.gamma))
        #expect(!parts.contains(.beta))
    }

    @Test("Binding nil coalescing operator reads fallback and writes source", .tags(.FormValidation.unit, .FormValidation.extensionMethods))
    func bindingNilCoalescingOperator() {
        // Arrange: create a nullable source and wrapped binding.
        var source: Int? = nil
        let optionalBinding = Binding<Int?>(
            get: { source },
            set: { source = $0 }
        )
        let nonOptional = optionalBinding ?? 10

        // Act: read fallback, then write a concrete value.
        let initialRead = nonOptional.wrappedValue
        nonOptional.wrappedValue = 42

        // Assert: verify fallback and propagation behavior.
        #expect(initialRead == 10)
        #expect(source == 42)
    }

    @Test("Publisher anyToVoid maps output values to void", .tags(.FormValidation.unit, .FormValidation.extensionMethods))
    func publisherAnyToVoidMapsValues() {
        // Arrange: create a passthrough publisher.
        let subject = PassthroughSubject<Int, Never>()
        var receivedCount = 0
        let cancellable = subject.anyToVoid.sink { receivedCount += 1 }
        defer { cancellable.cancel() }

        // Act: emit two values through the source publisher.
        subject.send(1)
        subject.send(2)

        // Assert: verify each source value emits one void output.
        #expect(receivedCount == 2)
    }

    @Test("Sequence keypath map and sort helpers", .tags(.FormValidation.unit, .FormValidation.extensionMethods))
    func sequenceKeyPathHelpers() {
        // Arrange: create sample model data.
        let models = [Model(value: 3), Model(value: 1), Model(value: 2)]

        // Act: map and sort using key-path helpers.
        let values = models.map(\.value)
        let sorted = models.sorted(by: \.value).map(\.value)

        // Assert: verify mapped and sorted outputs.
        #expect(values == [3, 1, 2])
        #expect(sorted == [1, 2, 3])
    }

    @Test("Async sequence helpers execute all elements", .tags(.FormValidation.integration, .FormValidation.extensionMethods))
    func asyncSequenceHelpersExecuteAllElements() async throws {
        // Arrange: define input values and an actor-backed collector.
        let values = [1, 2, 3]
        let collector = ValueCollector()

        // Act: run async and concurrent helpers.
        let mapped = try await values.asyncMap { $0 * 2 }
        try await values.concurrentForEach { value in
            await collector.append(value)
        }

        // Assert: verify all values were transformed and processed.
        #expect(mapped == [2, 4, 6])
        #expect(await collector.count == 3)
    }

    @MainActor
    @Test("View helper methods build without side effects", .tags(.FormValidation.integration, .FormValidation.view, .FormValidation.extensionMethods))
    func viewHelperMethodsBuild() async {
        // Arrange: create inputs for view extension methods.
        let subject = PassthroughSubject<Void, Never>()
        var validation: FormValidationResult? = nil
        let binding = Binding<FormValidationResult?>(
            get: { validation },
            set: { validation = $0 }
        )
        var animationFlag = false

        // Act: apply environment/view helpers and await animation helper.
        _ = Text("Demo").formAppearance(.default)
        _ = Text("Demo").validationResult(binding)
        _ = Text("Demo").validateForm(using: subject)
        _ = Text("Demo").shake(true)
        await Text("Demo").animate(duration: 0.001) {
            animationFlag = true
        }

        // Assert: verify helper execution completed.
        #expect(animationFlag)
    }
}

private struct Model: Sendable {
    let value: Int
}

private struct TestFlags: OptionSet {
    let rawValue: Int

    static let alpha = TestFlags(rawValue: 1 << 0)
    static let beta = TestFlags(rawValue: 1 << 1)
    static let gamma = TestFlags(rawValue: 1 << 2)
}

private actor ValueCollector {
    private var values: [Int] = []

    func append(_ value: Int) {
        values.append(value)
    }

    var count: Int {
        values.count
    }
}
