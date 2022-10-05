//
//  FormValidationResult.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

infix operator ~==

public enum FormValidationResult: Equatable {
    case valid
    case info(message: String)
    case warning(message: String)
    case error(message: String)
    
    public static func ~==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid), (.info, .info), (.warning, .warning), (.error, .error):
            return true
        default:
            return false
        }
    }
}

extension FormValidationResult {
    public var isValid: Bool {
        (self ~== .valid) || (self ~== .info(message: "")) || (self ~== .warning(message: ""))
    }
}
