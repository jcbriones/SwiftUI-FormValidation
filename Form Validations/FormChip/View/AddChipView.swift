//
//  AddChipView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct AddChipView: View {

    // MARK: - Body

    var body: some View {
        HStack {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .light))
        }.padding(7.5)
            .foregroundColor(AppColor.formTextColor())
            .background(AppColor.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(AppColor.lightGray, lineWidth: 1)
            )
    }

}
