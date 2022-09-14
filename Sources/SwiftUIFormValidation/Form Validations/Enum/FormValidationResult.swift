//
//  FormValidationResult.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public enum FormValidationResult: Equatable {
    case valid
    case info(message: String)
    case warning(message: String)
    case error(message: String)
}
