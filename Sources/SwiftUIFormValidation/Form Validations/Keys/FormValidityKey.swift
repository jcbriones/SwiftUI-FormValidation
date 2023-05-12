//
//  File.swift
//  
//
//  Created by Jc Briones on 10/4/22.
//

import SwiftUI

struct FormValidityKey: PreferenceKey {
    static let defaultValue: Bool = true

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue() && value
    }
}
