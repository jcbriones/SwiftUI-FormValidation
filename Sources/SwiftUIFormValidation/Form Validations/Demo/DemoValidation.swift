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
                Text("xloc.demo.header", bundle: .module)
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
        .navigationTitle("xloc.demo.title")
    }

    private var chip: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Sample Chip Set",
                               .chip(value: $viewModel.selectedChips,
                                     collection: NumberChip.allCases))
        }
    }
    private var pickers: some View {
        VStack(spacing: 8) {
            FormValidationView(header: "Item Picker",
                               .itemPicker(value: $viewModel.selectedItem,
                                           placeholder: "Select",
                                           collection: NumberChip.allCases))
            .disabled(viewModel.textView2.isEmpty)
            FormValidationView(
                header: "Date Picker",
                .datePicker(
                    value: $viewModel.date1,
                    imageName: nil,
                    in: .now...Date.distantFuture,
                    displayedComponents: .date
                )
            )
            .disabled(viewModel.textView2.isEmpty)
        }
    }
    private var formattedTextFields: some View {
        VStack(spacing: 8) {
            FormValidationView(
                header: "Boolean Selector",
                isRequired: false,
                .boolean(value: $viewModel.boolean,
                         textForNo: "If False",
                         textForYes: "If True")
            )
            FormValidationView(
                header: "Date Formatted Required",
                isRequired: true,
                validators: [.requiredField(fieldName: "Date formatter")],
                .formattedTextField(value: $viewModel.date2,
                                    formatter: .dateTime,
                                    placeholder: "Write a text and remove it")
            )
            FormValidationView(
                header: "Number Formatted Required",
                isRequired: true,
                validators: [.requiredField(fieldName: "Number formatter")],
                .formattedTextField(value: $viewModel.text1,
                                    formatter: .number,
                                    placeholder: "Write a text and remove it")
            )
            .disabled(viewModel.textView2.isEmpty)
            if #available(iOS 16.0, *) {
                FormValidationView(
                    header: "URL Formatted Required",
                    isRequired: true,
                    validators: [.requiredField(fieldName: "URL formatter")],
                    .formattedTextField(value: $viewModel.text3,
                                        formatter: .url,
                                        placeholder: "Write a text and remove it")
                )
            }
            FormValidationView(
                header: "Monetary (Fixed)",
                footerMessage: "Valid: 1 - 1000",
                validators: [
                    .characterLimit(characterLimit: 10),
                    .minMaxValidator(minError: 1.0, maxError: 1000.0)
                ],
                validatorDelay: .seconds(1),
                .formattedTextField(
                    value: $viewModel.minMax1,
                    formatter: .currency(code: "USD").precision(.fractionLength(0)),
                    placeholder: "$"
                )
            )
            FormValidationView(
                header: "Monetary (2 Digit Fraction)",
                footerMessage: "Valid: 0 - \(viewModel.minMax1?.formatted() ?? "100") _Based on **Monetary (Fixed)**_",
                validators: [
                    .characterLimit(characterLimit: 10),
                    .minMaxValidator(minWarning: 0, maxWarning: viewModel.minMax1 ?? 100)
                ],
                .formattedTextField(
                    value: $viewModel.minMax2,
                    formatter: .currency(code: "USD").precision(.fractionLength(2)),
                    placeholder: "$"
                )
            )
            FormValidationView(
                header: "Percentage",
                footerMessage: "No Limit Range",
                .formattedTextField(
                    value: $viewModel.text5,
                    formatter: .percent,
                    placeholder: "%"
                )
            )
            FormValidationView(
                header: "Percentage (2 Decimal Places)",
                footerMessage: "Enter from 0.0 to 100.0",
                validators: [
                    .characterLimit(characterLimit: 10),
                    .minMaxValidator(minWarning: 0.0, maxWarning: 100.0)
                ],
                .formattedTextField(
                    value: $viewModel.text5,
                    formatter: .percent.precision(.integerAndFractionLength(integer: 3, fraction: 2)),
                    placeholder: "%"
                )
            )
        }
    }
    private var textEditors: some View {
        VStack(spacing: 8) {
            FormValidationView(
                header: "Text View example with validation",
                validators: [
                    .regexMatch("TextView")
                ],
                .textEditor(
                    value: $viewModel.textView1,
                    placeholder: "Type a regex string value here. Or enter _TextView_ to remove the error on this field"
                )
            )
            FormValidationView(
                header: "Text View example with validation based on other field",
                validators: [
                    .regexMatch(viewModel.textView1)
                ],
                .textEditor(
                    value: $viewModel.textView2,
                    placeholder: "Type in \"Hello\" on the text field above and \"Hello\" on this field to throw error on both"
                )
            )
            FormValidationView(
                header: "Text View example with character limit",
                maxCharCount: 20,
                .textEditor(
                    value: $viewModel.textView3,
                    placeholder: "A field that has a maximum of 20 characters long"
                )
            )
        }
    }
}

class DemoValidationViewModel: ObservableObject {
    @Published var selectedChips: [NumberChip] = [.first, .second, .third, .fourth, .fifth]
    @Published var selectedItem: NumberChip?
    @Published var minMax1: Double?
    @Published var minMax2: Double?
    @Published var textView1: String = "^[0-9]+$"
    @Published var textView2: String = ""
    @Published var textView3: String = ""

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
