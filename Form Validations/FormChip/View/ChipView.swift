//
//  ChipView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct ChipView: View {

    @Environment(\.isEnabled) private var isEnabled: Bool

    // MARK: - Properties

    let systemImage: String?
    let titleKey: LocalizedStringKey
    var onRemove: () -> Void

    // MARK: - Body

    var body: some View {
        HStack {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .light))
            }
            Text(titleKey).lineLimit(1)
                .textStyle(.body1, foregroundColor: AppColor.formTextColor(isEnabled: isEnabled))
            if isEnabled {
                Button {
                    onRemove()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(AppColor.lightGray)
                }
                .buttonStyle(.borderless)
            }
        }.padding(.horizontal, 10).padding(.vertical, 5)
            .foregroundColor(AppColor.primaryText)
            .background(isEnabled ? AppColor.white : AppColor.paleGray)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(AppColor.lightGray, lineWidth: 1)
            )
    }

}
