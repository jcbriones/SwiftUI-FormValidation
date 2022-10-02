//
//  FormValidationContent.swift
//  
//
//  Created by Jc Briones on 9/24/22.
//

import Foundation
import SwiftUI

public protocol FormValidationContent: View {
    associatedtype Value: Equatable
    var value: Value { get set }
}
