//
//  FormTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

struct FormTextFieldValidationView: FormValidationView {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: String

    var imageName: String?
    var placeholder: LocalizedStringKey = ""

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(AppColor.lightGray)
            }
            TextField(placeholder, text: $value)
                .focused($focused)
                .textFieldStyle(LandingTextFieldStyle())
                .disabled(!isEnabled)
        }
        .overlay(alignment: .bottom) {
            Divider()
                .frame(height: focused ? 2 : 1.5)
                .background(AppColor.formValidationColor(focused: focused, validationResult: validationResult))
                .animation(.spring(), value: focused)
                .animation(.spring(), value: validationResult)
        }
    }

    // MARK: - Private API

    private var borderColor: Color {
        switch validationResult {
        case .valid:
            return focused ? AppColor.accent : AppColor.lightGray
        case .warning:
            return .yellow
        case .error:
            return .red
        case .info:
            return .blue
        }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
