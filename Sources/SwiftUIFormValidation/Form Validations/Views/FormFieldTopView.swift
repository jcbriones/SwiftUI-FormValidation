//
//  FormFieldTopView.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/23/25.
//  Copyright © 2025 PetCollab, LLC. All rights reserved.
//

import SwiftUI

struct FormFieldTopView<Value: Equatable>: View {
    @Environment(\.formAppearance)
    private var appearance
    @Environment(\.isFocused)
    private var isFocused

    // MARK: - Properties

    @Binding var value: Value
    var header: LocalizedStringResource?
    var isRequired: Bool

    var body: some View {
        if let header {
            HStack {
                if isRequired {
                    (Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(
                            isFocused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor
                        )
                     +
                     Text(appearance.requiredSymbol)
                        .accessibilityLabel(
                            String(localized: .Validator.required)
                        )
                            .font(appearance.titleHeaderFont)
                            .foregroundColor(appearance.requiredFieldSymbolTextColor))
                    .animation(appearance.animation, value: isFocused)
                } else {
                    Text(header)
                        .font(appearance.titleHeaderFont)
                        .foregroundColor(
                            isFocused ? appearance.activeTitleHeaderColor : appearance.inactiveTitleHeaderColor
                        )
                        .animation(appearance.animation, value: isFocused)
                }
            }.accessibilityAddTraits([.isHeader])
        }
    }
}
