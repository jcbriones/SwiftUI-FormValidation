//
//  AddChipView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public struct AddChipView: View {
    var appearance: FormValidationViewAppearance

    @Environment(\.isFocused) private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: - Body

    public var body: some View {
        HStack {
            Image(systemName: "plus")
                .font(appearance.textFieldFont)
        }.padding(7.5)
            .foregroundColor(appearance.formTextColor(focused: isFocused, isEnabled: isEnabled))
            .background(appearance.enabledBackgroundColor)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(appearance.inactiveBorderColor, lineWidth: 1)
            )
    }

}
