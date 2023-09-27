//
//  ChipView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public struct ChipView: View {
    var appearance: FormValidationViewAppearance

    @Environment(\.isFocused) private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: - Properties

    let systemImage: String?
    let imageUrl: URL?
    let titleKey: LocalizedStringKey
    var onRemove: () -> Void

    // MARK: - Body

    public var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .light))
            } else if let imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        EmptyView()
                    } else {
                        ProgressView().controlSize(.mini)
                    }
                }.frame(width: 14, height: 14).clipShape(Circle())
            }
            Text(titleKey).lineLimit(1)
                .font(appearance.textFieldFont)
                .foregroundColor(appearance.formTextColor(focused: isFocused, isEnabled: isEnabled))
            if isEnabled {
                Button {
                    onRemove()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(appearance.activeBorderColor)
                }
                .buttonStyle(.borderless)
            }
        }.padding(.horizontal, 10).padding(.vertical, 5)
            .foregroundColor(appearance.activeTextColor)
            .background(isEnabled ? appearance.enabledBackgroundColor : appearance.disabledBackgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(appearance.inactiveBorderColor, lineWidth: 1)
            )
    }

}
