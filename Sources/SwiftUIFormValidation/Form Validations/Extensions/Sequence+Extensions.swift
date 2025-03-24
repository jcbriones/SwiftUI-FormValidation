//
//  Sequence+Extensions.swift
//  SwiftUIFormValidation
//
//  Created by Jc Briones on 3/15/23.
//  Copyright © 2023 PetCollab, LLC. All rights reserved.
//

import Foundation

extension Sequence where Element: Sendable {
    /// Using the `asyncMap` method allows multiple async task to transform elements one at a time and return the completed task before continuing.
    /// - Parameter transform: A closure that takes an element of the sequence as a
    ///   parameter.
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    /// Using the `asyncForEach` method allows multiple async task to be run one at a time and return the completed task before continuing.
    /// - Parameter operation: A closure that takes an element of the sequence as a
    ///   parameter.
    func asyncForEach(_ operation: (Element) async throws -> Void) async rethrows {
        for element in self {
            try await operation(element)
        }
    }

    /// Using the `concurrentMap` method allows multiple async task to transform elements all at the once and wait for all the task to finish.
    /// - Parameter transform: A closure that takes an element of the sequence as a
    ///   parameter.

    func concurrentMap<T: Sendable>(_ transform: @escaping @Sendable (Element) async throws -> T) async throws -> [T] {
        let tasks = map { element in
            Task { @Sendable in
                try await transform(element)
            }
        }

        return try await tasks.asyncMap { task in
            try await task.value
        }
        //        try await withThrowingTaskGroup(of: T.self) { group in
        //            for element in self {
        //                group.addTask {
        //                    return try await transform(element)
        //                }
        //            }
        //            var results: [T] = []
        //            for try await result in group {
        //                results.append(result)
        //            }
        //
        //            return results
        //        }
    }

    /// Using the `concurrentForEach` method allows multiple async task to be run all at the once and wait for all the task to finish.
    /// - Parameter operation: A closure that takes an element of the sequence as a
    ///   parameter.
    func concurrentForEach(_ operation: @escaping @Sendable (Element) async throws -> Void) async throws {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try await operation(element)
                }
            }
        }
    }
}

// MARK: - Using KeyPaths

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
