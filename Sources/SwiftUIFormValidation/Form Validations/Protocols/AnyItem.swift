//
//  AnyItem.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 PetCollab, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public protocol AnyItem: Sendable, Identifiable, Equatable {
    /// Image from local assets
    var image: String? { get }
    /// Image from SF Symbols
    var systemImage: String? { get }
    /// Remote image
    var imageUrl: URL? { get }
    /// Primary item's localized string
    var localizedString: LocalizedStringResource { get }
    /// Secondary item's localized stirng
    var secondaryLocalizedString: LocalizedStringResource? { get }
}

public extension AnyItem {
    var image: String? { nil }
    var systemImage: String? { nil }
    var imageUrl: URL? { nil }
    var secondaryLocalizedString: LocalizedStringResource? { nil }
}
