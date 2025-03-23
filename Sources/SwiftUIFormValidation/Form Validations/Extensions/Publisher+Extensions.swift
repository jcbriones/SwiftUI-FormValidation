//
//  Publisher+Extensions.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/27/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import Combine

public extension Publisher where Self.Failure == Never {
    var anyToVoid: AnyPublisher<Void, Never> {
        return self
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
