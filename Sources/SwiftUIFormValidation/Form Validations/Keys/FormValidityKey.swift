//
//  File.swift
//  
//
//  Created by Jc Briones on 10/4/22.
//

import SwiftUI

public struct FormValidityKey: PreferenceKey {
    public static let defaultValue: Bool = true
    
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue() && value
    }
}

