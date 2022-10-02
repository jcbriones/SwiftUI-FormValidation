//
//  FormTextFieldFormattedValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/25/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextFieldFormattedValidationView<F>: FormValidationContent where F: ParseableFormatStyle, F.FormatOutput == String, F.FormatInput: Equatable {
    
    // MARK: - Initializer
    
    public init(value: Binding<F.FormatInput?>, formatter: F, imageName: String? = nil, placeholder: LocalizedStringKey = "") {
        self._value = value
        self.formatter = formatter
        self.imageName = imageName
        self.placeholder = placeholder
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: F.FormatInput?
    
    private let formatter: F
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(appearance.imageIconColor)
            }
            TextField(placeholder, value: $value, format: formatter)
                .focused($focused)
                .textFieldStyle(LandingTextFieldStyle())
                .disabled(!isEnabled)
        }
        .overlay(alignment: .bottom) {
            if isEnabled {
                Divider()
                    .frame(height: focused ? 2 : 1.5)
                    .background(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                    .animation(.spring(), value: focused)
                    .animation(.spring(), value: validationResult)
            }
        }
    }
    
}
