//
//  Binding+Extensions.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 4/28/24.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
