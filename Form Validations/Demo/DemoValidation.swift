//
//  DemoValidation.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct DemoValidation: View {

    @StateObject private var viewModel = DemoValidationViewModel()
    @State var date1: Date = .now
    @State var date2: Date? = .now
    @State var text1: Double? = 0
    @State var text2: String? = "helloworld"
    @State var text3: URL? = URL(string: "https://madeby.jcbriones.com")
    @State var text4: Double? = 1200
    @State var text5: Double? = 1.2
    @State var text6: Double?
    @State var boolean: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    Text("Form Validations View Examples")
                        .textStyle(.h3Headline)
                        .padding(.vertical, 20)
                    VStack(spacing: 8) {
                        FormPickerValidationView(header: "Picker",
                                                 value: $viewModel.selectedItem,
                                                 placeholder: "Select",
                                                 collection: NumberChip.allCases)
                        .disabled(viewModel.textView2.isEmpty)
                        FormDatePickerValidationView(header: "Date Picker",
                                                     isRequired: true,
                                                     value: $date1,
                                                     placeholder: "Pick a date and time")
                    }
                    VStack(spacing: 8) {
                        FormBooleanSelectorValidationView(header: "Boolean Selector",
                                                          isRequired: false,
                                                          value: $boolean,
                                                          enabledText: "If True",
                                                          disabledText: "If False")
                        FormTextFieldFormattedValidationView(header: "Date Formatted Required",
                                                             isRequired: true,
                                                             value: $date2,
                                                             formatter: .dateTime,
                                                             placeholder: "Write a text and remove it")
                        HStack(alignment: .top, spacing: 8) {
                            FormTextFieldFormattedValidationView(header: "Number Formatted Required",
                                                                 isRequired: true,
                                                                 value: $text1,
                                                                 formatter: .number,
                                                                 placeholder: "Write a text and remove it")
                            .disabled(viewModel.textView2.isEmpty)
                            if #available(iOS 16.0, *) {
                                FormTextFieldFormattedValidationView(header: "URL Formatted Required",
                                                                     isRequired: true,
                                                                     value: $text3,
                                                                     formatter: .url,
                                                                     placeholder: "Write a text and remove it")
                            }
                        }
                        HStack(alignment: .top, spacing: 8) {
                            FormTextFieldFormattedValidationView(header: "Monetary (Fixed)",
                                                                 leftFooterMessage: "Valid: 1 - 1000",
                                                                 value: $viewModel.minMax1,
                                                                 formatter: .currency(code: "USD").precision(.fractionLength(0)),
                                                                 placeholder: "$",
                                                                 trigger: viewModel.validatorGroup1.eraseToAnyPublisher(),
                                                                 validators: [])
                            FormTextFieldFormattedValidationView(header: "Monetary (2 Digit Fraction)",
                                                                 leftFooterMessage: "Valid: 100 - 800",
                                                                 value: $viewModel.minMax2,
                                                                 formatter: .currency(code: "USD").precision(.fractionLength(2)),
                                                                 placeholder: "$",
                                                                 trigger: viewModel.validatorGroup1.eraseToAnyPublisher(),
                                                                 validators: [])
                        }
                        HStack(alignment: .top, spacing: 8) {
                            FormTextFieldFormattedValidationView(header: "Percentage",
                                                                 leftFooterMessage: "No Limit Range",
                                                                 value: $text5,
                                                                 formatter: .percent,
                                                                 placeholder: "%")
                            FormTextFieldFormattedValidationView(header: "Percentage (2 Decimal Places)",
                                                                 leftFooterMessage: "Enter from 0.0 to 100.0",
                                                                 value: $text5,
                                                                 formatter: .percent.precision(.integerAndFractionLength(integer: 3, fraction: 2)),
                                                                 placeholder: "%")
                        }
                    }
                    VStack(spacing: 8) {
                        FormChipValidationView(header: "Sample Chip Set",
                                               value: $viewModel.selectedChips,
                                               collection: NumberChip.allCases)
                        .disabled(viewModel.textView1.isEmpty == true)
                    }
                    VStack(spacing: 8) {
                        FormTextViewValidationView(header: "Text View example with validation",
                                                   value: $viewModel.textView1,
                                                   placeholder: "Type in \"textview\" to throw error",
                                                   maxCharCount: 150,
                                                   trigger: viewModel.validatorGroup2.eraseToAnyPublisher(),
                                                   validators: [])
                        .disabled(!viewModel.textView2.isEmpty)
                        FormTextViewValidationView(header: "Text View example with validation based on other field",
                                                   value: $viewModel.textView2,
                                                   placeholder: "Type in \"uh-oh\" on the text field above and \"hello\" on this field to throw error",
                                                   trigger: viewModel.validatorGroup2.eraseToAnyPublisher())
                        .disabled(!viewModel.textView1.isEmpty)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
            .navigationBarTitle("Validations")
            .background(AppColor.background)
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

}

struct DemoValidation_Previews: PreviewProvider {
    static var previews: some View {
        DemoValidation()
    }
}
