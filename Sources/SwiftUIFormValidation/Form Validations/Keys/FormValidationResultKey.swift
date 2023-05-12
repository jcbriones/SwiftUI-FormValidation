//
//  FormValidationResultKey.swift
//
//
//  Created by Jc Briones on 10/1/22.
//

import SwiftUI

struct FormValidationResultKey: EnvironmentKey {
    static let defaultValue: FormValidationResult = .valid
}

public extension EnvironmentValues {
    var formValidationResult: FormValidationResult {
        get { self[FormValidationResultKey.self] }
        set { self[FormValidationResultKey.self] = newValue }
    }
}
