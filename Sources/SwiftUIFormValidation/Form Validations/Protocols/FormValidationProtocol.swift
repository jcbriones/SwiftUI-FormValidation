//
//  FormValidationProtocol.swift
//  
//
//  Created by Jc Briones on 9/24/22.
//

import Foundation
import SwiftUI

public protocol FormValidationProtocol: View {
    associatedtype Content: View
    func content(_ appearance: FormValidationViewAppearance) -> Content
}
