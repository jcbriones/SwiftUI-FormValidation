//
//  AnySelectableItem.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 10/23/24.
//

import SwiftUI

public protocol AnySelectableItem: AnyItem {
    var enabled: Bool { get }
}

public extension AnySelectableItem {
    var enabled: Bool { true }
}
