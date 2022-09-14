//
//  FormPickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
struct FormPickerValidationView<Item>: FormValidationView where Item: AnyChip {

    // MARK: - Private Properties

    @Environment(\.isEnabled) var isEnabled: Bool
    @FocusState var focused: Bool
    @State var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    let header: String
    var leftFooterMessage: String = ""
    var rightFooterMessage: String = ""
    var isRequired: Bool = false
    @Binding var value: Item?

    var placeholder: LocalizedStringKey
    var collection: [Item]

    var trigger: AnyPublisher<Void, Never>?
    var validators: [FormValidator] = []

    // MARK: - Body

    var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        Menu {
            ForEach(collection, id: \.id) { item in
                Button {
                    value = item
                } label: {
                    Text(item.titleKey)
                        .frame(maxWidth: .infinity)
                        .font(appearance.textFieldFont)
                        .multilineTextAlignment(.leading)
                }
            }
        } label: {
            Text(value?.titleKey ?? placeholder)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: value != nil))
                .multilineTextAlignment(.leading)
        }
        .focused($focused)
        .padding(10)
        .disabled(!isEnabled)
        .overlay(alignment: .bottom) {
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(appearance.formValidationColor(focused: focused, validationResult: validationResult))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            }
        }
        .overlay(alignment: .trailing) {
            if isEnabled {
                Image(systemName: focused ? "chevron.up" : "chevron.down")
                    .foregroundColor(focused ? appearance.activeBorderColor : appearance.inactiveBorderColor)
                    .animation(.spring(), value: focused)
                    .padding(.trailing, 10)
            }
        }
    }

    // MARK: - Validator

    func validate() {
        validationResult = validators.validate(value)
    }

}
