//
//  FormValidationContent.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 9/24/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

public struct FormModel<Value: Equatable>: Identifiable {
    public var id: UUID
    var header: LocalizedStringKey?
    var footer: LocalizedStringKey?
    var validators: [any FormValidator]

    public init(header: LocalizedStringKey? = nil) {
        self.id = UUID()
        self.header = header
        self.footer = nil
        self.validators = []
    }
}
public protocol FormValidationContent: View {
    associatedtype Value: Equatable
    var value: Value { get set }
    var model: FormModel<Value> { get set }
}
