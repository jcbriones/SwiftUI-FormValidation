//
//  FormAppearanceKey.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 10/1/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

@MainActor
struct FormAppearanceKey: Sendable, @preconcurrency EnvironmentKey {
    static let defaultValue: any FormValidationViewAppearance = .default
}

public extension EnvironmentValues {
    var formAppearance: FormValidationViewAppearance {
        get { self[FormAppearanceKey.self] }
        set { self[FormAppearanceKey.self] = newValue }
    }
}
