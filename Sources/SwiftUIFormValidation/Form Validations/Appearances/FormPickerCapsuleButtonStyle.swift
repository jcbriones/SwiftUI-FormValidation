//
//  FormPickerCapsuleButtonStyle.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

struct FormPickerCapsuleButtonStyle: ButtonStyle {
    internal init(_ isSelected: Bool, appearance: FormValidationViewAppearance? = nil) {
        self.isSelected = isSelected
        enabledFont = appearance?.titleHeaderFont ?? .body
        disabledFont = appearance?.titleHeaderFont ?? .body
        selectedForegroundColor = appearance?.enabledBackgroundColor ?? .white
        selectedBackgroundColor = appearance?.activeTitleHeaderColor ?? .accentColor
        unselectedForegroundColor = appearance?.activeTitleHeaderColor ?? .accentColor
        disabledForegroundColor = appearance?.disabledTextColor ?? .white
        disabledBackgroundColor = appearance?.disabledBackgroundColor ?? .gray
    }

    @Environment(\.isEnabled)
    private var isEnabled
    private var isSelected: Bool
    
    private let enabledFont: Font
    private let disabledFont: Font
    private let selectedForegroundColor: Color
    private let selectedBackgroundColor: Color
    private let unselectedForegroundColor: Color
    private let disabledForegroundColor: Color
    private let disabledBackgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        if isEnabled {
            if isSelected {
                configuration.label
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(selectedBackgroundColor)
                    .font(enabledFont)
                    .foregroundColor(selectedForegroundColor)
                    .clipShape(Capsule())
            } else {
                configuration.label
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .font(enabledFont)
                    .foregroundColor(unselectedForegroundColor)
                    .overlay(Capsule().stroke(unselectedForegroundColor, lineWidth: 1.5))
            }
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
