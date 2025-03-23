//
//  ExternalValidationResultKey.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 5/21/24.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

struct ExternalValidationResultKey: EnvironmentKey {
    static let defaultValue: Binding<FormValidationResult?> = .constant(nil)
}

public extension EnvironmentValues {
    var externalValidationResult: Binding<FormValidationResult?> {
        get { self[ExternalValidationResultKey.self] }
        set { self[ExternalValidationResultKey.self] = newValue }
    }
}
