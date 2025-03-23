//
//  Shake.swift
//  Mostly copied from https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
//
//  Created by Jc Briones on 4/26/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import SwiftUI

struct Shake: GeometryEffect {
    var offsetRange: CGFloat = 10
    var repeatCount: Int = 3
    var animatableData: CGFloat

    nonisolated func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: offsetRange * sin(animatableData * .pi * CGFloat(repeatCount)),
                y: 0
            )
        )
    }
}
