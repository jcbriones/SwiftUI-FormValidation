//
//  FormPickerCapsuleButtonStyle.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

struct FormPickerCapsuleButtonStyle: ButtonStyle {
    internal init(appearance: FormValidationViewAppearance? = nil) {
        enabledFont = appearance?.titleHeaderFont ?? .body
        disabledFont = appearance?.titleHeaderFont ?? .body
        enabledForegroundColor = appearance?.inactiveTitleHeaderColor ?? .primary
        enabledBorderColor = appearance?.inactiveBorderColor ?? .primary
        disabledForegroundColor = .white
        disabledBackgroundColor = appearance?.accentBackgroundColor ?? .accentColor
    }

    @Environment(\.isEnabled) private var isEnabled: Bool
    private let enabledFont: Font
    private let disabledFont: Font
    private let enabledForegroundColor: Color
    private let enabledBorderColor: Color
    private let disabledForegroundColor: Color
    private let disabledBackgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        if isEnabled {
            configuration.label
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .font(enabledFont)
                .foregroundColor(enabledForegroundColor)
                .overlay(Capsule().stroke(enabledBorderColor, lineWidth: 1.5))
        } else {
            configuration.label
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(disabledBackgroundColor)
                .font(disabledFont)
                .foregroundColor(disabledForegroundColor)
                .clipShape(Capsule())
        }

    }
}
