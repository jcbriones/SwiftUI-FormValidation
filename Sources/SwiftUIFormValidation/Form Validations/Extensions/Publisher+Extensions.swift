//
//  Publisher+Extensions.swift
//  
//
//  Created by Jc Briones on 3/27/23.
//

import Combine

public extension Publisher where Self.Failure == Never {
    var anyToVoid: AnyPublisher<Void, Never> {
        return self
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
