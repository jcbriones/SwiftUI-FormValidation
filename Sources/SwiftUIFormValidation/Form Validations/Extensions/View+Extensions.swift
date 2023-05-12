//
//  View+Extension.swift
//  
//
//  Created by Jc Briones on 9/23/22.
//

import SwiftUI
import Combine

public extension View {
    func formAppearance(_ appearance: FormValidationViewAppearance) -> some View {
        environment(\.formAppearance, appearance)
    }

    func onFormValidityChanged(isValid: @escaping (Bool) -> Void) -> some View {
        onPreferenceChange(FormValidityKey.self, perform: isValid)
    }

    func isFormValid(_ value: Bool) -> some View {
        preference(key: FormValidityKey.self, value: value)
    }

    func shake(
        _ shake: Bool,
        offsetRange: CGFloat = 10,
        repeatCount: Int = 3
    ) -> some View {
        modifier(Shake(offsetRange: offsetRange, repeatCount: repeatCount, animatableData: CGFloat(shake ? 1 : 2)))
            .animation(.default, value: shake)
    }

    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.linear(duration: duration)) {
                execute()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
}
