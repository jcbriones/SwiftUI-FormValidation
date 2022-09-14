//
//  FormPickerCapsuleButtonStyle.swift
//  Recomdy
//
//  Created by Jc Briones on 9/13/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI

struct FormPickerCapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    var enabledFont: Font = .body
    var disabledFont: Font = .body
    var enabledForegroundColor: Color = .primary
    var enabledBorderColor: Color = .primary
    var disabledForegroundColor: Color = .white
    var disabledBackgroundColor: Color = .accentColor
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
