////
////  FormValidation.swift
////  Recomdy
////
////  Created by Jc Briones on 8/27/22.
////  Copyright © 2022 Recomdy, LLC. All rights reserved.
////
//
//import SwiftUI
//import Combine
//
//public protocol FormValidation {
//    var requireFontColor: Color { get }
//    var requireSymbol: String { get }
//    var isRequired: Bool { get set }
//    var appearance: FormValidationViewAppearance { get set }
//    
//    associatedtype ContentBody: FormValidationContent
//    var content: ContentBody { get }
//}
//
//extension FormValidation {
//    public var requireFontColor: Color { appearance.requiredFieldSymbolTextColor }
//    public var requireSymbol: String { " *" }
//}
