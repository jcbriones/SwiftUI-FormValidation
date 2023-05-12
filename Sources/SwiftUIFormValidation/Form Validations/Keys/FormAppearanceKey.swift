//
//  FormAppearanceKey.swift
//  
//
//  Created by Jc Briones on 10/1/22.
//

import SwiftUI

struct FormAppearanceKey: EnvironmentKey {
    static let defaultValue: FormValidationViewAppearance = .default
}

public extension EnvironmentValues {
    var formAppearance: FormValidationViewAppearance {
        get { self[FormAppearanceKey.self] }
        set { self[FormAppearanceKey.self] = newValue }
    }
}
