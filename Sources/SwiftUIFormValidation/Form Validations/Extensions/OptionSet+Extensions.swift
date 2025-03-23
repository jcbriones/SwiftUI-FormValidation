//
//  OptionSet+Extensions.swift
//  SwiftUI-FormValidation
//
//  Created by Jc Briones on 3/3/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import Foundation

public extension OptionSet where RawValue: FixedWidthInteger, Self == Self.Element {
    var components: [Self] { rawValue.bitComponents.map(Self.init) }
}
