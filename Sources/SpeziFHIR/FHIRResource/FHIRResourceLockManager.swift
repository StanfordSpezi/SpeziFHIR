//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation

final class FHIRResourceLockManager: @unchecked Sendable {
    private var locks = [String: NSRecursiveLock]()
    private let lockQueue = DispatchQueue(label: "com.fhir.resource.lockmanager", attributes: .concurrent)

    func withLock<T>(for identityKey: String, execute block: () throws -> T) throws -> T {
        let lock = getLock(for: identityKey)

        lock.lock()
        defer { lock.unlock() }

        return try block()
    }

    private func getLock(for identityKey: String) -> NSRecursiveLock {
        let existingLock = lockQueue.sync {
            locks[identityKey]
        }

        if let existingLock = existingLock {
            return existingLock
        }

        return lockQueue.sync(flags: .barrier) {
            if let existingLock = locks[identityKey] {
                return existingLock
            }

            let newLock = NSRecursiveLock()
            locks[identityKey] = newLock
            return newLock
        }
    }
}
