//
//  FormValidationContent.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 9/24/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormModel<Value: Equatable>: Identifiable {
    public var id: UUID = UUID()
    var header: LocalizedStringKey?
    var footer: LocalizedStringKey?
    var validators: [any FormValidator] = []
}
public protocol FormValidationContent: View {
    associatedtype Value: Equatable
    var value: Value { get set }
    var model: FormModel<Value> { get set }
}
