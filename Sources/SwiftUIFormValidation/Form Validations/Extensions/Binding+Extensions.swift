//
//  Binding+Extensions.swift
//  
//
//  Created by Jc Briones on 4/28/24.
//

import SwiftUI

public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
