//
//  FormDatePickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
public struct FormDatePickerValidationView: FormValidationView {
    
    // MARK: - Initializer
    
    public init(header: String, leftFooterMessage: String = "", rightFooterMessage: String = "", isRequired: Bool = false, value: Binding<Date>, imageName: String? = nil, placeholder: LocalizedStringKey = "", trigger: AnyPublisher<Void, Never>? = nil, validators: [FormValidator] = []) {
        self.header = header
        self.leftFooterMessage = leftFooterMessage
        self.rightFooterMessage = rightFooterMessage
        self.isRequired = isRequired
        self._value = value
        self.imageName = imageName
        self.placeholder = placeholder
        self.trigger = trigger
        self.validators = validators
    }
    
    // MARK: - Private Properties

    @Environment(\.isEnabled) public var isEnabled: Bool
    @FocusState public var focused: Bool
    @State public var validationResult: FormValidationResult = .valid

    // MARK: - Public Properties

    public let header: String
    public var leftFooterMessage: String = ""
    public var rightFooterMessage: String = ""
    public var isRequired: Bool = false
    @Binding public var value: Date

    public var imageName: String?
    public var placeholder: LocalizedStringKey = ""

    public var trigger: AnyPublisher<Void, Never>?
    public var validators: [FormValidator] = []

    // MARK: - Body

    public var body: some View {
        createView(innerBody)
    }

    var innerBody: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(appearance.imageIconColor)
            }
            DatePicker("", selection: $value, in: PartialRangeFrom(.now))
                .labelsHidden()
                .datePickerStyle(.compact)
                .focused($focused)
                .disabled(!isEnabled)
        }
    }

    // MARK: - Validator

    public func validate() {
        validationResult = validators.validate(value)
    }

}
