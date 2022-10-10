//
//  DemoValidation.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

#if DEBUG
struct DemoValidation: View {
    
    @StateObject private var viewModel = DemoValidationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Form Validations View Examples")
                    .font(.headline)
                    .padding(.vertical, 20)
                Group {
                    chip
                    pickers
                    formattedTextFields
                    textEditors
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitle("Validations")
    }
    
    private var chip: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Sample Chip Set",
                               .chip(value: $viewModel.selectedChips,
                                     collection: NumberChip.allCases))
            .disabled(viewModel.textView1.isEmpty == true)
        }
    }
    private var pickers: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Item Picker",
                               .itemPicker(value: $viewModel.selectedItem,
                                           placeholder: LocalizedStringKey("Select"),
                                           collection: NumberChip.allCases))
            .disabled(viewModel.textView2.isEmpty)
            FormValidationView(header: "Date Picker",
                               .datePicker(value: $viewModel.date1,
                                           imageName: nil,
                                           placeholder: LocalizedStringKey("Pick a date and time")))
            .disabled(viewModel.textView2.isEmpty)
        }
    }
    private var formattedTextFields: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Boolean Selector",
                               isRequired: false,
                               .boolean(value: $viewModel.boolean,
                                        enabledText: "If True",
                                        disabledText: "If False"))
            FormValidationView(header: "Date Formatted Required",
                               isRequired: true,
                               validators: [.requiredField(fieldName: "Date formatter")],
                               .formattedTextField(value: $viewModel.date2,
                                                   formatter: .dateTime,
                                                   placeholder: LocalizedStringKey("Write a text and remove it")))
            FormValidationView(header: "Number Formatted Required",
                               isRequired: true,
                               validators: [.requiredField(fieldName: "Number formatter")],
                               .formattedTextField(value: $viewModel.text1,
                                                   formatter: .number,
                                                   placeholder: LocalizedStringKey("Write a text and remove it")))
            .disabled(viewModel.textView2.isEmpty)
            if #available(iOS 16.0, *) {
                FormValidationView(header: "URL Formatted Required",
                                   isRequired: true,
                                   validators: [.requiredField(fieldName: "URL formatter")],
                                   .formattedTextField(value: $viewModel.text3,
                                                       formatter: .url,
                                                       placeholder: LocalizedStringKey("Write a text and remove it")))
            }
            FormValidationView(header: "Monetary (Fixed)",
                               footerMessage: "Valid: 1 - 1000",
                               validators: [.characterLimit(characterLimit: 10), .minMaxValidator(minError: 1.0, maxError: 1000.0)],
                               .formattedTextField(value: $viewModel.minMax1,
                                                   formatter: .currency(code: "USD").precision(.fractionLength(0)),
                                                   placeholder: LocalizedStringKey("$")))
            FormValidationView(header: "Monetary (2 Digit Fraction)",
                               footerMessage: "Valid: 100 - 800",
                               validators: [.characterLimit(characterLimit: 10), .minMaxValidator(minWarning: 100.0, maxWarning: 800.0)],
                               .formattedTextField(value: $viewModel.minMax2,
                                                   formatter: .currency(code: "USD").precision(.fractionLength(2)),
                                                   placeholder: LocalizedStringKey("$")))
            FormValidationView(header: "Percentage",
                               footerMessage: "No Limit Range",
                               .formattedTextField(value: $viewModel.text5,
                                                   formatter: .percent,
                                                   placeholder: LocalizedStringKey("%")))
            FormValidationView(header: "Percentage (2 Decimal Places)",
                               footerMessage: "Enter from 0.0 to 100.0",
                               validators: [.characterLimit(characterLimit: 10), .minMaxValidator(minWarning: 0.0, maxWarning: 100.0)],
                               .formattedTextField(value: $viewModel.text5,
                                                   formatter: .percent.precision(.integerAndFractionLength(integer: 3, fraction: 2)),
                                                   placeholder: LocalizedStringKey("%")))
        }.formTrigger(viewModel.validatorGroup1.eraseToAnyPublisher())
    }
    private var textEditors: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Text View example with validation",
                               validators: [],
                               .textEditor(value: $viewModel.textView1,
                                           placeholder: "Type in \"textview\" to throw error",
                                           maxCharCount: 150))
            .disabled(!viewModel.textView2.isEmpty)
            FormValidationView(header: "Text View example with validation based on other field",
                               .textEditor(value: $viewModel.textView2,
                                           placeholder: "Type in \"uh-oh\" on the text field above and \"hello\" on this field to throw error"))
            .disabled(!viewModel.textView1.isEmpty)
        }.formTrigger(viewModel.validatorGroup2.eraseToAnyPublisher())
    }
}

class DemoValidationViewModel: ObservableObject {
    var validatorGroup1 = PassthroughSubject<Void, Never>()
    var validatorGroup2 = PassthroughSubject<Void, Never>()
    @Published var selectedChips: [NumberChip] = [.first, .second, .third, .fourth, .fifth]
    @Published var selectedItem: NumberChip?
    @Published var minMax1: Double? {
        didSet {
            validatorGroup1.send()
        }
    }
    @Published var minMax2: Double? {
        didSet {
            validatorGroup1.send()
        }
    }
    @Published var textView1: String = "" {
        didSet {
            validatorGroup2.send()
        }
    }
    @Published var textView2: String = "" {
        didSet {
            validatorGroup2.send()
        }
    }
    
    @Published var date1: Date = Date()
    @Published var date2: Date? = Date()
    @Published var text1: Double? = 0
    @Published var text2: String? = "helloworld"
    @Published var text3: URL? = URL(string: "https://madeby.jcbriones.com")
    @Published var text4: Double? = 1200
    @Published var text5: Double? = 1.2
    @Published var text6: Double?
    @Published var boolean: Bool = false
}

struct DemoValidation_Previews: PreviewProvider {
    static var previews: some View {
        DemoValidation()
    }
}
#endif
