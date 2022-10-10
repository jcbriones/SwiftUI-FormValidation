//
//  FormTriggerKey.swift
//  
//
//  Created by Jc Briones on 10/10/22.
//

import SwiftUI
import Combine

public struct FormTriggerKey: EnvironmentKey {
    public static let defaultValue: AnyPublisher<Void, Never>? = nil
}

public extension EnvironmentValues {
    var formTrigger: AnyPublisher<Void, Never>? {
        get { self[FormTriggerKey.self] }
        set { self[FormTriggerKey.self] = newValue }
    }
}
