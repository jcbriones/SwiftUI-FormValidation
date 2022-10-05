//
//  View+Extension.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI


extension View {
    func formAppearance(_ appearance: FormValidationViewAppearance) -> some View {
        environment(\.formAppearance, appearance)
    }
    
    func onFormValidityChanged(isValid: @escaping (Bool) -> Void) -> some View {
        onPreferenceChange(FormValidityKey.self, perform: isValid)
    }
    
    func isFormValid(_ value: Bool) -> some View {
        preference(key: FormValidityKey.self, value: value)
    }
}
