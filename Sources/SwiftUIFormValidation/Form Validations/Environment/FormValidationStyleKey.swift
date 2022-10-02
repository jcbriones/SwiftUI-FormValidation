//
//  FormAppearanceKey.swift
//
//
//  Created by Jc Briones on 10/1/22.
//

import SwiftUI

public struct FormValidationStyleKey: EnvironmentKey {
    public static let defaultValue: FormValidationStyleConfiguration = FormValidationStyleConfiguration(content: FormEmptyValidationView(), appearance: .default)
}

extension EnvironmentValues {
    public var formValidationStyle: FormValidationStyleConfiguration {
        get { self[FormValidationStyleKey.self] }
        set { self[FormValidationStyleKey.self] = newValue }
    }
}

extension View where Self == FormValidationView {
    func formValidationStyle(_ configuration: FormValidationStyleConfiguration) -> some View {
        environment(\.formValidationStyle, configuration)
    }
}
