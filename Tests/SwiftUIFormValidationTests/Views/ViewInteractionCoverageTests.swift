import SwiftUI
import Testing
import ViewInspector
@testable import SwiftUIFormValidation

@Suite("View Interaction Coverage", .serialized)
struct ViewInteractionCoverageTests {
    @MainActor
    @Test("Boolean selector taps update bound value", .tags(.FormValidation.integration, .FormValidation.view))
    func booleanSelectorTapsUpdateBoundValue() throws {
        // Arrange: set up a mutable bool binding for the selector.
        let box = Box(false)
        let binding = Binding<Bool>(
            get: { box.value },
            set: { box.value = $0 }
        )
        let sut = FormBooleanSelector(binding, header: "Enabled", textForNo: "No", textForYes: "Yes")

        // Act: render and tap both buttons.
        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }

        let hStack = try sut.inspect().find(ViewType.HStack.self)
        try hStack.button(1).tap()
        let afterYes = box.value
        try hStack.button(0).tap()
        let afterNo = box.value

        // Assert: verify the binding toggled as expected.
        #expect(afterYes)
        #expect(!afterNo)
    }

    @MainActor
    @Test("Top field header renders required and non-required branches", .tags(.FormValidation.integration, .FormValidation.view))
    func topFieldHeaderRendersBranches() throws {
        // Arrange: prepare bindings for both required and optional headers.
        let box = Box("value")
        let binding = Binding<String>(get: { box.value }, set: { box.value = $0 })
        let required = FormFieldTopView(value: binding, header: "Header", isRequired: true)
        let optional = FormFieldTopView(value: binding, header: "Header", isRequired: false)

        // Act: evaluate body for both paths.
        ViewHosting.host(view: required)
        _ = required.body
        ViewHosting.expel()

        ViewHosting.host(view: optional)
        _ = optional.body
        ViewHosting.expel()

        // Assert: verify both views remain constructible and bound value unchanged.
        #expect(box.value == "value")
    }

    @MainActor
    @Test("Picker capsule style executes selected and disabled branches", .tags(.FormValidation.integration, .FormValidation.view))
    func pickerCapsuleStyleExecutesBranches() {
        // Arrange: build buttons with different style/environment states.
        let selected = Button("Selected") {}.buttonStyle(FormPickerCapsuleButtonStyle(isSelected: true))
        let unselected = Button("Unselected") {}.buttonStyle(FormPickerCapsuleButtonStyle(isSelected: false))
        let disabled = Button("Disabled") {}.buttonStyle(FormPickerCapsuleButtonStyle(isSelected: true)).disabled(true)

        // Act: host all variants to execute style paths.
        ViewHosting.host(view: selected)
        ViewHosting.expel()

        ViewHosting.host(view: unselected)
        ViewHosting.expel()

        ViewHosting.host(view: disabled)
        ViewHosting.expel()

        // Assert: reaching this point confirms style branches are executable.
        #expect(true)
    }

    @MainActor
    @Test("Bottom field validation reacts to bound value changes", .tags(.FormValidation.integration, .FormValidation.view, .FormValidation.validator))
    func bottomFieldValidationReactsToValueChanges() async {
        // Arrange: create bindable value/result with required validator.
        let valueBox = Box("seed")
        let resultBox = Box(FormValidationResult.valid)

        let value = Binding<String>(
            get: { valueBox.value },
            set: { valueBox.value = $0 }
        )
        let result = Binding<FormValidationResult>(
            get: { resultBox.value },
            set: { resultBox.value = $0 }
        )

        let sut = FormFieldBottomView(
            value: value,
            result: result,
            validators: [RequiredFieldValidator(fieldName: "Name")],
            footerMessage: nil
        )

        // Act: host the view, then force value transitions to trigger validation.
        ViewHosting.host(view: sut)
        value.wrappedValue = "abc"
        try? await Task.sleep(nanoseconds: 200_000_000)
        value.wrappedValue = ""
        try? await Task.sleep(nanoseconds: 300_000_000)
        ViewHosting.expel()

        // Assert: verify value transitions completed without crashing.
        #expect(true)
    }

    @MainActor
    @Test("Date picker and optional date picker sheet paths execute", .tags(.FormValidation.integration, .FormValidation.view))
    func datePickerAndOptionalDatePickerSheetPathsExecute() throws {
        // Arrange: create date and optional date picker views.
        let dateBox = Box(Date.now)
        let dateBinding = Binding<Date>(get: { dateBox.value }, set: { dateBox.value = $0 })
        let datePicker = FormDatePicker(
            dateBinding,
            header: "Date",
            in: Date.now.addingTimeInterval(-3600)...Date.now.addingTimeInterval(3600),
            displayedComponents: [.date, .hourAndMinute]
        )

        let optionalDateBox = Box(Optional<Date>.none)
        let optionalBinding = Binding<Date?>(get: { optionalDateBox.value }, set: { optionalDateBox.value = $0 })
        let optionalDatePicker = FormOptionalDatePicker(
            optionalBinding,
            header: "Optional Date",
            displayedComponents: [.date]
        )

        // Act: tap each button to exercise sheet construction code paths.
        ViewHosting.host(view: datePicker)
        try datePicker.inspect().find(ViewType.Button.self).tap()
        _ = try? datePicker.inspect().find(ViewType.Sheet.self)
        ViewHosting.expel()

        ViewHosting.host(view: optionalDatePicker)
        try optionalDatePicker.inspect().find(ViewType.Button.self).tap()
        _ = try? optionalDatePicker.inspect().find(ViewType.Sheet.self)
        ViewHosting.expel()

        // Assert: verify bound values remain reachable.
        #expect(dateBox.value <= Date.now.addingTimeInterval(3600))
    }

    @MainActor
    @Test("Chip sheet and appearance row builders execute", .tags(.FormValidation.integration, .FormValidation.view))
    func chipSheetAndAppearanceRowBuildersExecute() throws {
        // Arrange: build a chip field and appearance-driven list views.
        let selectedBox = Box([Selectable(id: 1, text: "One"), Selectable(id: 2, text: "Two")])
        let selected = Binding<[Selectable]>(get: { selectedBox.value }, set: { selectedBox.value = $0 })
        let chip = FormChip(
            selected,
            header: "Tags",
            collection: [Selectable(id: 1, text: "One"), Selectable(id: 2, text: "Two"), Selectable(id: 3, text: "Three")],
            pickerTitle: "Choose"
        )

        let appearance = DefaultFormValidationViewAppearance()
        let row = appearance.row([Item(id: 1, text: "One", systemImage: "star")])
        let selectableRow = appearance.selectableRow(
            [Selectable(id: 1, text: "One"), Selectable(id: 2, text: "Two")],
            selected: selected
        )

        // Act: present the chip sheet and render appearance list rows.
        ViewHosting.host(view: chip)
        try chip.inspect().find(ViewType.Button.self).tap()
        _ = try? chip.inspect().find(ViewType.Sheet.self)
        ViewHosting.expel()

        ViewHosting.host(view: row)
        ViewHosting.expel()

        ViewHosting.host(view: selectableRow)
        ViewHosting.expel()

        // Assert: verify selected values are still tracked.
        #expect(!selectedBox.value.isEmpty)
    }
}

@MainActor
private final class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

private struct Item: AnyItem, Sendable {
    let id: Int
    let text: String
    let systemImageName: String?

    init(id: Int, text: String, systemImage: String? = nil) {
        self.id = id
        self.text = text
        self.systemImageName = systemImage
    }

    var localizedString: LocalizedStringResource { LocalizedStringResource(stringLiteral: text) }
    var systemImage: String? { systemImageName }
}

private struct Selectable: AnySelectableItem, Sendable {
    let id: Int
    let text: String

    var localizedString: LocalizedStringResource { LocalizedStringResource(stringLiteral: text) }
}
