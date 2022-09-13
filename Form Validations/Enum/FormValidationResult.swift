//
//  FormValidationResult.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

enum FormValidationResult: Equatable {
    case valid
    case info(message: String)
    case warning(message: String)
    case error(message: String)
}

extension FormValidationResult {

    var borderColor: Color {
        switch self {
        case .valid:
            return AppColor.darkGray
        case .info:
            return .blue
        case .warning:
            return .yellow
        case .error:
            return .red
        }
    }

}
