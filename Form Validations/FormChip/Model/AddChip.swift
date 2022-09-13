//
//  AddChip.swift
//  Recomdy
//
//  Created by Jc Briones on 8/27/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct AddChip: AnyChip {
    let id = UUID()
    var systemImage: String?
    var titleKey: LocalizedStringKey = ""
}
