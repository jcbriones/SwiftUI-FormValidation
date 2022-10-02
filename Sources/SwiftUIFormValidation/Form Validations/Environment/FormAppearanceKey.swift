//
//  FormAppearanceKey.swift
//  
//
//  Created by Jc Briones on 10/1/22.
//

import SwiftUI

public struct FormAppearanceKey: EnvironmentKey {
    public static let defaultValue: FormValidationViewAppearance = .default
}

extension EnvironmentValues {
    public var formAppearance: FormValidationViewAppearance {
        get { self[FormAppearanceKey.self] }
        set { self[FormAppearanceKey.self] = newValue }
    }
}

extension View where Self : FormValidationContent {
    func formAppearance(_ appearance: FormValidationViewAppearance) -> some View {
        environment(\.formAppearance, appearance)
    }
}
