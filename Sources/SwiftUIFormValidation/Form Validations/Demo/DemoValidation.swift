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
                Group {
                    Text("Form Validations View Examples")
                        .font(.headline)
                        .padding(.vertical, 20)
                    VStack(spacing: 8) {
                        FormValidationView(header: "Item Picker",
                                           FormItemPickerValidationView(value: $viewModel.selectedItem,
                                                       placeholder: "Select",
                                                       collection: NumberChip.allCases))
                        .disabled(viewModel.textView2.isEmpty)
                        FormValidationView(header: "Date Picker",
                                           .datePicker(value: $viewModel.date1,
                                                       imageName: nil,
                                                       placeholder: "Pick a date and time"))
                        .disabled(viewModel.textView2.isEmpty)
                    }
                    VStack(spacing: 8) {
                        FormValidationView(header: "Boolean Selector",
                                           isRequired: false,
                                           .boolean(value: $viewModel.boolean,
                                                    enabledText: "If True",
                                                    disabledText: "If False"))
                        FormValidationView(header: "Date Formatted Required",
                                           isRequired: true,
                                           FormFormattedTextFieldValidationView(value: $viewModel.date2,
                                                               formatter: .dateTime,
                                                               placeholder: "Write a text and remove it"))
                        HStack(alignment: .top, spacing: 8) {
                            FormValidationView(header: "Number Formatted Required",
                                               isRequired: true,
                                               FormFormattedTextFieldValidationView(value: $viewModel.text1,
                                                                   formatter: .number,
                                                                   placeholder: "Write a text and remove it"))
                            .disabled(viewModel.textView2.isEmpty)
                            if #available(iOS 16.0, *) {
                                FormValidationView(header: "URL Formatted Required",
                                                   isRequired: true,
                                                   FormFormattedTextFieldValidationView(value: $viewModel.text3,
                                                                       formatter: .url,
                                                                       placeholder: "Write a text and remove it"))
                            }
                        }
                        HStack(alignment: .top, spacing: 8) {
                            FormValidationView(header: "Monetary (Fixed)",
                                               footerMessage: "Valid: 1 - 1000",
                                               trigger: viewModel.validatorGroup1.eraseToAnyPublisher(),
                                               validators: [],
                                               FormFormattedTextFieldValidationView(value: $viewModel.minMax1,
                                                                   formatter: .currency(code: "USD").precision(.fractionLength(0)),
                                                                   placeholder: "$"))
                            FormValidationView(header: "Monetary (2 Digit Fraction)",
                                               footerMessage: "Valid: 100 - 800",
                                               trigger: viewModel.validatorGroup1.eraseToAnyPublisher(),
                                               validators: [],
                                               FormFormattedTextFieldValidationView(value: $viewModel.minMax2,
                                                                   formatter: .currency(code: "USD").precision(.fractionLength(2)),
                                                                   placeholder: "$"))
                        }
                        HStack(alignment: .top, spacing: 8) {
                            FormValidationView(header: "Percentage",
                                               footerMessage: "No Limit Range",
                                               FormFormattedTextFieldValidationView(value: $viewModel.text5,
                                                                   formatter: .percent,
                                                                   placeholder: "%"))
                            FormValidationView(header: "Percentage (2 Decimal Places)",
                                               footerMessage: "Enter from 0.0 to 100.0",
                                               FormFormattedTextFieldValidationView(value: $viewModel.text5,
                                                                   formatter: .percent.precision(.integerAndFractionLength(integer: 3, fraction: 2)),
                                                                   placeholder: "%"))
                        }
                    }
                    VStack(spacing: 8) {
                        FormValidationView(header: "Sample Chip Set",
                                           FormChipValidationView(value: $viewModel.selectedChips,
                                                 collection: NumberChip.allCases))
                        .disabled(viewModel.textView1.isEmpty == true)
                    }
                    VStack(spacing: 8) {
                        FormValidationView(header: "Text View example with validation",
                                           trigger: viewModel.validatorGroup2.eraseToAnyPublisher(),
                                           validators: [],
                                           .textEditor(value: $viewModel.textView1,
                                                       placeholder: "Type in \"textview\" to throw error",
                                                       maxCharCount: 150))
                        .disabled(!viewModel.textView2.isEmpty)
                        FormValidationView(header: "Text View example with validation based on other field",
                                           trigger: viewModel.validatorGroup2.eraseToAnyPublisher(),
                                           .textEditor(value: $viewModel.textView2,
                                                       placeholder: "Type in \"uh-oh\" on the text field above and \"hello\" on this field to throw error"))
                        .disabled(!viewModel.textView1.isEmpty)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitle("Validations")
        .background(Color.white)
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
    
    @State var date1: Date = Date()
    @State var date2: Date? = Date()
    @State var text1: Double? = 0
    @State var text2: String? = "helloworld"
    @State var text3: URL? = URL(string: "https://madeby.jcbriones.com")
    @State var text4: Double? = 1200
    @State var text5: Double? = 1.2
    @State var text6: Double?
    @State var boolean: Bool = false
}

struct DemoValidation_Previews: PreviewProvider {
    static var previews: some View {
        DemoValidation()
    }
}
#endif
