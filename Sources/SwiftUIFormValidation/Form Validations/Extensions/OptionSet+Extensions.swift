//
//  OptionSet+Extensions.swift
//  
//
//  Created by Jc Briones on 3/3/23.
//

import Foundation

public extension OptionSet where RawValue: FixedWidthInteger, Self == Self.Element {
    var components: [Self] { rawValue.bitComponents.map(Self.init) }
}
