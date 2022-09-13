//
//  AnyChip.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

protocol AnyChip: Identifiable, Equatable {
    var systemImage: String? { get }
    var titleKey: LocalizedStringKey { get }
}
