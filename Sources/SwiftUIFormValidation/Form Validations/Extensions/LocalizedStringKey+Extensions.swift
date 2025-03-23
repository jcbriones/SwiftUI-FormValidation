//
//  LocalizedStringKey+Extensions.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/5/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import SwiftUI

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self)
            .children
            .first { $0.label == "key" }?
            .value as? String
    }

    func stringValue(defaultValue: String? = nil, table: String? = nil) -> String {
        Bundle.main.localizedString(forKey: self.stringKey ?? "", value: defaultValue, table: table)
    }
}
