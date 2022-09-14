//
//  LandingTextFieldStyle.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

struct LandingTextFieldStyle: TextFieldStyle {
    var font: Font = .body
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(font)
            .multilineTextAlignment(.leading)
            .padding(5)
    }
}
