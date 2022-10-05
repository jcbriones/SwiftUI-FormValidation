//
//  UIApplication+Extensions.swift
//  Recomdy
//
//  Created by Jc Briones on 9/23/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
