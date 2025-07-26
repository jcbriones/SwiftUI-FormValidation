//
//  FormPickerCapsuleButtonStyle.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import SwiftUI

struct FormPickerCapsuleButtonStyle: ButtonStyle {
    @Environment(\.formAppearance)
    private var appearance
    @Environment(\.isEnabled)
    private var isEnabled

    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        if isEnabled {
            if isSelected {
                configuration.label
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(appearance.activeTitleHeaderColor)
                    .font(appearance.titleHeaderFont)
                    .foregroundColor(appearance.enabledBackgroundColor)
                    .clipShape(Capsule())
                    .contentShape(Capsule())
            } else {
                configuration.label
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .font(appearance.titleHeaderFont)
                    .foregroundColor(appearance.activeTitleHeaderColor)
                    .overlay(Capsule().stroke(appearance.activeTitleHeaderColor, lineWidth: 1.5))
                    .contentShape(Capsule())
            }
        } else {
            configuration.label
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(appearance.disabledBackgroundColor)
                .font(appearance.titleHeaderFont)
                .foregroundColor(appearance.inactiveTextColor)
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
    }
}
