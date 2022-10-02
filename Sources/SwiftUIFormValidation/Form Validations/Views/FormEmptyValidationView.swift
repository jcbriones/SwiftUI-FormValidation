//
//  FormEmptyValidationView.swift
//  Recomdy
//
//  Created by Jc Briones on 8/26/22.
//  Copyright © 2022 Recomdy, LLC. All rights reserved.
//

import SwiftUI
import Combine

public struct FormEmptyValidationView: FormValidationContent {
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Private Properties
    
    @Environment(\.formAppearance) private var appearance: FormValidationViewAppearance
    @State public var value: Bool = true
    
    // MARK: - Body
    
    public var body: some View {
        EmptyView()
    }
}
