//
//  ExternalValidatorKey.swift
//
//
//  Created by Jc Briones on 5/31/24.
//

@preconcurrency import Combine
import SwiftUI

struct ExternalValidatorKey: EnvironmentKey {
    static let defaultValue: PassthroughSubject<Void, Never> = .init()
}

public extension EnvironmentValues {
    var externalValidator: PassthroughSubject<Void, Never> {
        get { self[ExternalValidatorKey.self] }
        set { self[ExternalValidatorKey.self] = newValue }
    }
}
