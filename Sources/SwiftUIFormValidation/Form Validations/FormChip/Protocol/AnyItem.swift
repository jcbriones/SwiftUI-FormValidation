//
//  AnyItem.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public protocol AnyItem: Identifiable, Equatable {
    var systemImage: String? { get }
    var imageUrl: URL? { get }
    var localizedString: LocalizedStringKey { get }
}

public extension AnyItem {
    var imageUrl: URL? { nil }
}
