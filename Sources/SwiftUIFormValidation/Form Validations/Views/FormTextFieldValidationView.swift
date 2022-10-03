//
//  FormTextFieldValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormTextFieldValidationView: FormValidationContent {

    // MARK: - Initializer
    
    public init(value: Binding<String>, imageName: String? = nil, placeholder: LocalizedStringKey = "") {
        self._value = value
        self.imageName = imageName
        self.placeholder = placeholder
    }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @Environment(\.isEnabled) private var isEnabled: Bool
    @FocusState private var focused: Bool
    @State private var validationResult: FormValidationResult = .valid
    @Binding public var value: String
    
    private let imageName: String?
    private let placeholder: LocalizedStringKey
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                Image(imageName).resizable().scaledToFit().frame(width: 27, height: 27).foregroundColor(appearance.imageIconColor)
            }
            TextField(placeholder, text: $value)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: focused, isEnabled: isEnabled))
                .multilineTextAlignment(.leading)
                .padding(5)
                .focused($focused)
                .disabled(!isEnabled)
        }
        .overlay(alignment: .bottom) {
            Divider()
                .frame(height: focused ? 2 : 1.5)
                .background(appearance.formValidationBorderColor(focused: focused, validationResult: validationResult))
                .animation(.spring(), value: focused)
                .animation(.spring(), value: validationResult)
        }
    }
    
}

extension FormValidationContent where Self == FormTextFieldValidationView {
    
    /// <#Description#>
    /// - Parameters:
    ///   - value: <#value description#>
    ///   - imageName: <#imageName description#>
    ///   - placeholder: <#placeholder description#>
    /// - Returns: <#description#>
    public static func textField(value: Binding<String>, imageName: String? = nil, placeholder: LocalizedStringKey = "") -> FormTextFieldValidationView {
        FormTextFieldValidationView(value: value, imageName: imageName, placeholder: placeholder)
    }
}
