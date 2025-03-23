//
//  DemoValidation.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Combine
import SwiftUI

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
                    formatterTextFields
                    formatTextFields
                    textEditors
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("xloc.demo.title")
    }

    private var chip: some View {
        VStack(spacing: 8) {
            FormChip(
                $viewModel.selectedChips,
                header: "Sample Chip Set",
                collection: NumberChip.allCases,
                pickerTitle: .init("Sample Selection")
            )
        }
    }
    private var pickers: some View {
        VStack(spacing: 8) {
            FormItemPicker(
                $viewModel.selectedItem,
                header: "Item Picker",
                placeholder: "Select",
                collection: NumberChip.allCases
            )
//            .validationResult($viewModel.validationResults["pickers1"])
            FormDatePicker(
                $viewModel.date1,
                header: "Date Picker",
                imageName: nil,
                in: .now...Date.distantFuture,
                displayedComponents: .date
            )
            .footerMessage("From today forward")
//            .validationResult($viewModel.validationResults["pickers2"])
            FormDatePicker(
                $viewModel.date1,
                header: "Date Picker",
                imageName: nil,
                in: nil,
                displayedComponents: .date
            )
            .validators([.requiredField(fieldName: "")])
//            .validationResult($viewModel.validationResults["pickers3"])
            FormOptionalDatePicker(
                $viewModel.date2,
                header: "Date Picker (Optional)",
                imageName: nil,
                in: nil,
                displayedComponents: .date
            )
            .validators([.requiredField(fieldName: "")])
            .validationResult($viewModel.validationResults["pickers4"])
            FormBooleanSelector(
                $viewModel.boolean,
                header: "Boolean Selector",
                textForNo: "If False",
                textForYes: "If True"
            )
//            .validationResult($viewModel.validationResults["pickers5"])
        }
        .validationResult($viewModel.validationResults["pickers"])
    }
    private var formatterTextFields: some View {
        VStack(spacing: 8) {
            FormFormatterTextField(
                $viewModel.date2,
                header: "Date Formatter",
                formatter: DateFormatter(),
                placeholder: "Write a text and remove it"
            )
            .validators([.requiredField(fieldName: "")])
//            .validationResult($viewModel.validationResults["formatterTextFields1"])
            FormFormatterTextField(
                $viewModel.text1,
                header: "Number Format",
                formatter: NumberFormatter(),
                placeholder: "Write a text and remove it"
            )
            .validators([.requiredField(fieldName: "")])
            .validationResult($viewModel.validationResults["formatterTextFields2"])
        }
    }
    private var formatTextFields: some View {
        VStack(spacing: 8) {
            FormFormatTextField(
                $viewModel.date2,
                header: "Date Format Required",
                format: .dateTime,
                placeholder: "Write a text in date format"
            )
            .validators([.requiredField(fieldName: "")])
            .validationResult($viewModel.validationResults["formatTextFields1"])

            FormFormatTextField(
                $viewModel.text1,
                header: "Number Format Required",
                format: .number,
                placeholder: "Write a text in number format"
            )
            .validators([.requiredField(fieldName: "")])
            .validationResult($viewModel.validationResults["formatTextFields2"])
            if #available(iOS 16.0, *) {
                FormFormatTextField(
                    $viewModel.text3,
                    header: "URL Format Required",
                    format: .url,
                    placeholder: "Enter a valid URL."
                )
                .validators([.requiredField(fieldName: "URL formatter")])
                .validationResult($viewModel.validationResults["formatTextFields3"])
            }
            FormFormatTextField(
                $viewModel.minMax1,
                header: "Monetary (Fixed)",
                format: .currency(code: "USD").precision(.fractionLength(0)),
                placeholder: "$"
            )
            .footerMessage("Valid: $1 - $1000")
            .validators([
                .characterLimit(characterLimit: 10),
                .minMaxValidator(minError: 1.0, maxError: 1000.0)
            ], delay: .seconds(1))
            .validationResult($viewModel.validationResults["formatTextFields4"])
            FormFormatTextField(
                $viewModel.minMax2,
                header: "Monetary (2 Digit Fraction)",
                format: .currency(code: "USD").precision(.fractionLength(2)),
                placeholder: "$"
            )
            .footerMessage(
                "Valid: $0 - \(viewModel.minMax1?.formatted(.currency(code: "USD")) ?? "$100") _Based on **Monetary (Fixed)**_"
            )
            .validators([
                .minMaxValidator(minWarning: 0, maxWarning: viewModel.minMax1 ?? 100)
            ])
            .validationResult($viewModel.validationResults["formatTextFields5"])
            FormFormatTextField(
                $viewModel.text5,
                header: "Percentage",
                format: .percent,
                placeholder: "%"
            )
            .footerMessage("No Limit Range")
            .validationResult($viewModel.validationResults["formatTextFields6"])
            FormFormatTextField(
                $viewModel.text5,
                header: "Percentage (3 Integer, 2 Decimal)",
                format: .percent.precision(.integerAndFractionLength(integer: 3, fraction: 2)),
                placeholder: "%"
            )
            .footerMessage("Enter from 0.0 to 100.0")
            .validators([
                .minMaxValidator(minWarning: 0.0, maxWarning: 100.0)
            ])
            .validationResult($viewModel.validationResults["formatTextFields7"])
        }
    }
    private var textEditors: some View {
        VStack(spacing: 8) {
            FormTextEditor(
                $viewModel.textView1,
                header: "Text View example with validation",
                placeholder: "Type a regex string value here. Or enter _TextView_ to remove the error on this field"
            )
            .validators([
                .regexMatch("TextView")
            ])
            .validationResult($viewModel.validationResults["textEditors1"])
            FormTextEditor(
                $viewModel.textView2,
                header: "Text View example with validation based on other field",
                placeholder: "This uses the regex validator you typed in above."
            )
            .validators([
                .regexMatch(viewModel.textView1)
            ])
            .validationResult($viewModel.validationResults["textEditors2"])
            FormTextEditor(
                $viewModel.textView3,
                header: "Text View example with character limit",
                placeholder: "A field that has a maximum of 20 characters long"
            )
            .validators([
                .characterLimit(characterLimit: 20)
            ])
            .validationResult($viewModel.validationResults["textEditors3"])

            Button("Validate") {
                viewModel.validate.send()
            }
        }
        .validateForm(using: viewModel.validate)
    }
}

class DemoValidationViewModel: ObservableObject {
    @Published var selectedChips: [NumberChip] = [.first, .second, .third, .fourth, .fifth]
    @Published var selectedItem: NumberChip?
    @Published var minMax1: Double?
    @Published var minMax2: Double?
    @Published var textView1: String = "^[0-9]+$"
    @Published var textView2: String = ""
    @Published var textView3: String = "12345123451234512345"

    @Published var date1: Date = Date()
    @Published var date2: Date?
    @Published var text1: Double? = 0
    @Published var text2: String? = "helloworld"
    @Published var text3: URL? = URL(string: "https://madeby.jcbriones.com")
    @Published var text4: Double? = 1200
    @Published var text5: Double? = 1.2
    @Published var text6: Double?
    @Published var boolean: Bool = false
    @Published var validationResults: [String: FormValidationResult] = [:] {
        didSet {
            print(validationResults)
        }
    }
    var validate: PassthroughSubject<Void, Never> = .init()
}

struct DemoValidation_Previews: PreviewProvider {
    static var previews: some View {
        DemoValidation()
    }
}
#endif
