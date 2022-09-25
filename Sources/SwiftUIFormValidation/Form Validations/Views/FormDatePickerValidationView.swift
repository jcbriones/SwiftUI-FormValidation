//
//  FormDatePickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormDatePickerValidationView: FormValidationProtocol {
    
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
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding private var value: Date
    
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    
    // MARK: - FormValidationProtocol Properties
    
    private let header: String
    private let leftFooterMessage: String
    private let rightFooterMessage: String
    private let isRequired: Bool
    private let trigger: AnyPublisher<Void, Never>?
    private let validators: [FormValidator]
    
    // MARK: - Body
    
    public var body: some View {
        FormValidationView(header: header, leftFooterMessage: leftFooterMessage, rightFooterMessage: rightFooterMessage, isRequired: isRequired, value: $value, trigger: trigger, validators: validators, content: content)
    }
    
    public func content(_ appearance: FormValidationViewAppearance) -> some View {
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
    
}
