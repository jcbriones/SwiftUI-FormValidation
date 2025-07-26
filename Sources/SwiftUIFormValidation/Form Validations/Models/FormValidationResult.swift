//
//  FormValidationResult.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation
import SwiftUI

infix operator ~==

@MainActor
public enum FormValidationResult: Equatable, Sendable {
    case valid
    case info(message: LocalizedStringResource)
    case warning(message: LocalizedStringResource)
    case error(message: LocalizedStringResource)

    public static func ~== (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid), (.info, .info), (.warning, .warning), (.error, .error):
            return true
        default:
            return false
        }
    }
}

public extension FormValidationResult {
    var isValid: Bool {
        (self ~== .valid) || (self ~== .info(message: "")) || (self ~== .warning(message: ""))
    }
}
