//
//  FormDatePickerValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormDatePickerValidationView: FormValidationContent {
    
    // MARK: - Initializer
    
    public init(value: Binding<Date>, imageName: String? = nil, placeholder: LocalizedStringKey = "") {
        self._value = value
        self.imageName = imageName
        self.placeholder = placeholder
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: Date
    
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    
    // MARK: - Body
    
    public var body: some View {
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

extension FormValidationContent where Self == FormDatePickerValidationView {
    
    /// New boolean form
    public static func datePicker(value: Binding<Date>, imageName: String? = nil, placeholder: LocalizedStringKey = "") -> FormDatePickerValidationView {
        FormDatePickerValidationView(value: value, imageName: imageName, placeholder: placeholder)
    }
}
