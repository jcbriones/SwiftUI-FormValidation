//
//  FixedWidthInteger+Extensions.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 3/3/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import Foundation

public extension FixedWidthInteger {
    init(bitComponents: [Self]) {
        self = bitComponents.reduce(0, +)
    }

    var bitComponents: [Self] {
        (0 ..< Self.bitWidth)
            .map { 1 << $0 }
            .filter { self & $0 != 0 }
    }
}
