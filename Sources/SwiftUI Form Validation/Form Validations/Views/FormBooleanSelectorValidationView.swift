//
//  FormBooleanSelectorValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
struct FormBooleanSelectorValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: Bool

    var enabledText: String
    var disabledText: String

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        HStack {
            Button(enabledText) {
                withAnimation {
                    value = true
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle())
                .disabled(value)
            Button(disabledText) {
                withAnimation {
                    value = false
                }
            }.buttonStyle(FormPickerCapsuleButtonStyle())
                .disabled(!value)
        }.padding(.vertical, 5)
            .padding(.horizontal, 10)
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
