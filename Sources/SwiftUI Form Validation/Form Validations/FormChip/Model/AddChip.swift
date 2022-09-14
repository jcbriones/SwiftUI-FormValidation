//
//  AddChip.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

public struct AddChip: AnyChip {
    public let id = UUID()
    public var systemImage: String?
    public var titleKey: LocalizedStringKey = ""
}
