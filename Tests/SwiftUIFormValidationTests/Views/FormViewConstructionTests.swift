import Foundation
import SwiftUI
import Testing
@testable import SwiftUIFormValidation

@Suite("Form View Construction")
struct FormViewConstructionTests {
    @MainActor
    @Test("Text and secure field initializers support optional bridge semantics", .tags(.FormValidation.integration, .FormValidation.view))
    func textAndSecureFieldOptionalBridgeSemantics() {
        // Arrange: create optional-backed bindings for string content.
        var optionalText: String? = nil
        let optionalTextBinding = Binding<String?>(
            get: { optionalText },
            set: { optionalText = $0 }
        )

        var textField = FormTextField(optionalTextBinding, header: "Email", systemName: "person", placeholder: "Email")
        var secureField = FormSecureField(optionalTextBinding, header: "Password", systemName: "lock", placeholder: "Password")

        // Act: write via bridged non-optional values.
        textField.value = "user@example.com"
        secureField.value = "secret"

        // Assert: verify writes flow back to optional source.
        #expect(optionalText == "secret")
        _ = textField.body
        _ = secureField.body
    }

    @MainActor
    @Test("Text editor and date pickers build body", .tags(.FormValidation.integration, .FormValidation.view))
    func textEditorAndDatePickersBuildBody() {
        // Arrange: create bindings for text and date values.
        var optionalText: String? = nil
        let textBinding = Binding<String?>(get: { optionalText }, set: { optionalText = $0 })
        var date = Date.now
        let dateBinding = Binding<Date>(get: { date }, set: { date = $0 })
        var optionalDate: Date? = .now
        let optionalDateBinding = Binding<Date?>(get: { optionalDate }, set: { optionalDate = $0 })

        let editor = FormTextEditor(textBinding, header: "Notes", placeholder: "Add details")
        let datePicker = FormDatePicker(dateBinding, header: "Date", in: Date.now.addingTimeInterval(-3600)...Date.now.addingTimeInterval(3600))
        let optionalDatePicker = FormOptionalDatePicker(optionalDateBinding, header: "Optional Date", displayedComponents: [.date, .hourAndMinute])

        // Act: evaluate each view body.
        _ = editor.body
        _ = datePicker.body
        _ = optionalDatePicker.body

        // Assert: verify the source bindings remain reachable.
        #expect(optionalText == nil)
        #expect(optionalDate != nil)
    }

    @MainActor
    @Test("Format and formatter text fields build body", .tags(.FormValidation.integration, .FormValidation.view))
    func formatAndFormatterFieldsBuildBody() {
        // Arrange: create bindings and formatter instances.
        var intValue: Int? = 42
        let intBinding = Binding<Int?>(get: { intValue }, set: { intValue = $0 })
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let formatField = FormFormatTextField(intBinding, header: "Amount", format: IntegerFormatStyle<Int>.number)
        let formatterField = FormFormatterTextField(intBinding, header: "Amount", formatter: numberFormatter)

        // Act: evaluate each view body.
        _ = formatField.body
        _ = formatterField.body

        // Assert: verify the bound value remains intact.
        #expect(intValue == 42)
    }

    @MainActor
    @Test("Boolean selector, picker, chip, and content extensions build", .tags(.FormValidation.integration, .FormValidation.view))
    func selectorPickerChipAndContentExtensionsBuild() {
        // Arrange: construct all collection-driven fields.
        var boolValue = false
        let boolBinding = Binding<Bool>(get: { boolValue }, set: { boolValue = $0 })
        let booleanSelector = FormBooleanSelector(boolBinding, header: "Enabled", textForNo: "No", textForYes: "Yes")

        var selectedItem: TestItem? = nil
        let selectedBinding = Binding<TestItem?>(get: { selectedItem }, set: { selectedItem = $0 })
        let items = [TestItem(id: 1, text: "One"), TestItem(id: 2, text: "Two")]
        let itemPicker = FormItemPicker(selectedBinding, header: "Item", placeholder: "Pick", collection: items)

        var selectedChips: [TestSelectableItem] = [TestSelectableItem(id: 1, text: "A")]
        let chipsBinding = Binding<[TestSelectableItem]>(get: { selectedChips }, set: { selectedChips = $0 })
        var chipField = FormChip(chipsBinding, header: "Tags", collection: [TestSelectableItem(id: 1, text: "A"), TestSelectableItem(id: 2, text: "B")], pickerTitle: "Select")

        // Act: apply content extension modifiers and evaluate body.
        chipField = chipField
            .footerMessage("Footer")
            .isRequired(true, customName: "Tags")
            .maxCharCount(10)
            .validators([RequiredFieldValidator(fieldName: "Tags")])

        _ = booleanSelector.body
        _ = itemPicker.body
        _ = chipField.body

        // Assert: verify extension methods changed the model state.
        #expect(chipField.model.footer != nil)
        #expect(chipField.model.validators.count == 1)
    }

    @MainActor
    @Test("Appearance and protocol defaults are reachable", .tags(.FormValidation.unit, .FormValidation.view))
    func appearanceAndProtocolDefaultsAreReachable() {
        // Arrange: prepare protocol-conforming test values.
        let appearance = DefaultFormValidationViewAppearance()
        var selected = [TestSelectableItem(id: 1, text: "A")]

        // Act: evaluate appearance and protocol helper methods.
        _ = appearance.formValidationBorderColor(focused: true, validationResult: .valid)
        _ = appearance.formValidationDescriptionTextColor(validationResult: .warning(message: "warn"))
        _ = appearance.formTextColor(focused: false, isEnabled: false)
        _ = appearance.row([TestItem(id: 1, text: "One")])
        _ = appearance.selectableRow([TestSelectableItem(id: 1, text: "A")], selected: Binding(get: { selected }, set: { selected = $0 }))

        let anyItem = TestItem(id: 3, text: "Three")
        let anySelectableItem = TestSelectableItem(id: 4, text: "Four")

        // Assert: verify default protocol properties are available.
        #expect(anyItem.image == nil)
        #expect(anyItem.systemImage == nil)
        #expect(anyItem.imageUrl == nil)
        #expect(anyItem.secondaryLocalizedString == nil)
        #expect(anySelectableItem.enabled)
    }

    @MainActor
    @Test("Environment keys and shake utility are reachable", .tags(.FormValidation.unit, .FormValidation.view))
    func environmentKeysAndShakeUtilityAreReachable() {
        // Arrange: prepare environment and utility values.
        var env = EnvironmentValues()
        var externalResult: FormValidationResult? = nil
        let binding = Binding<FormValidationResult?>(get: { externalResult }, set: { externalResult = $0 })

        // Act: set and read environment entries.
        env.formValidationResult = .warning(message: "warn")
        env.externalValidationResult = binding
        env.externalValidator = .init()
        env.formAppearance = .default

        let shake = Shake(offsetRange: 8, repeatCount: 2, animatableData: 0.5)
        _ = shake.effectValue(size: .init(width: 10, height: 10))

        // Assert: verify key writes were persisted.
        if case .warning = env.formValidationResult {
            #expect(true)
        } else {
            Issue.record("Expected warning validation result in environment")
        }
        #expect(env.externalValidationResult.wrappedValue == nil)
    }

    @MainActor
    @Test("Chip views and top/bottom field wrappers build body", .tags(.FormValidation.integration, .FormValidation.view))
    func chipViewsAndFieldWrappersBuildBody() {
        // Arrange: create values and bindings for top/bottom wrappers.
        var text = "Hello"
        let textBinding = Binding<String>(get: { text }, set: { text = $0 })
        var result: FormValidationResult = .valid
        let resultBinding = Binding<FormValidationResult>(get: { result }, set: { result = $0 })

        // Act: build chip subviews and form wrapper views.
        let addChip = AddChipView(appearance: .default)
        let chip = ChipView(
            appearance: .default,
            systemImage: "star",
            imageUrl: nil,
            titleKey: "Demo",
            onRemove: {}
        )
        let top = FormFieldTopView(value: textBinding, header: "Header", isRequired: true)
        let bottom = FormFieldBottomView(
            value: textBinding,
            result: resultBinding,
            validators: [CharacterLimitValidator(characterLimit: 10)],
            footerMessage: "Footer"
        )
        let modifier = FormFieldContentModifier(textBinding, model: .init(header: "Header"))

        _ = addChip.body
        _ = chip.body
        _ = top.body
        _ = bottom.body
        _ = Text("Body").modifier(modifier)

        // Assert: verify no unexpected value mutations occurred.
        #expect(text == "Hello")
        #expect(result == .valid)
    }

#if DEBUG
    @MainActor
    @Test("Demo screen and view model are constructible", .tags(.FormValidation.integration, .FormValidation.view))
    func demoScreenAndViewModelAreConstructible() {
        // Arrange: create demo view and view model.
        let demo = DemoValidation()
        let viewModel = DemoValidationViewModel()

        // Act: evaluate view body and mutate one observed value.
        _ = demo.body
        viewModel.validationResults["example"] = .valid
        viewModel.validate.send()

        // Assert: verify defaults and mutation are available.
        #expect(!viewModel.selectedChips.isEmpty)
        #expect(viewModel.validationResults["example"] == .valid)
    }
#endif
}

private struct TestItem: AnyItem, Sendable {
    let id: Int
    let text: String

    var localizedString: LocalizedStringResource { LocalizedStringResource(stringLiteral: text) }
}

private struct TestSelectableItem: AnySelectableItem, Sendable {
    let id: Int
    let text: String

    var localizedString: LocalizedStringResource { LocalizedStringResource(stringLiteral: text) }
}
