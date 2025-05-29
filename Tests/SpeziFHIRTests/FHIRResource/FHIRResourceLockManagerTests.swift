//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@testable import SpeziFHIR
import Testing

@Suite
struct FHIRResourceLockManagerTests {
    private enum Constants {
        static let shortDelay: TimeInterval = 0.005
        static let longDelay: TimeInterval = 0.05
        static let shortTimeout: TimeInterval = 4.0
        static let longTimeout: TimeInterval = 20.0
        static let iterations = 100
        static let standardIdentityKey = "test-resource-1"
        static let multipleIdentityKeys = [
            "test-resource-1",
            "test-resource-2",
            "test-resource-3",
            "test-resource-4",
            "test-resource-5"
        ]
    }

    private let lockManager = FHIRResourceLockManager()

    @Test("FHIRResourceLockManager - Lock Protection Test")
    func testLockProtection() throws {
        let identityKey = Constants.standardIdentityKey

        let orderTracker = UnsafeOrderTracker()
        let counter = UnsafeCounter()

        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

        group.enter()
        queue.async {
            do {
                try lockManager.withLock(for: identityKey) {
                    orderTracker.append(1)
                    counter.increment(after: Constants.longDelay)
                    orderTracker.append(-1)
                }
                group.leave()
            } catch {
                Issue.record("Lock execution failed: \(error)")
                group.leave()
            }
        }

        group.enter()
        queue.async {
            do {
                try lockManager.withLock(for: identityKey) {
                    orderTracker.append(2)
                    counter.increment(after: Constants.longDelay)
                    orderTracker.append(-2)
                }
                group.leave()
            } catch {
                Issue.record("Lock execution failed: \(error)")
                group.leave()
            }
        }

        let timeoutResult = group.wait(timeout: .now() + Constants.shortTimeout)
        #expect(timeoutResult == .success, "Operations timed out")

        #expect(counter.value == 2, "With proper locking, counter should be 2 but got \(counter.value)")

        #expect(orderTracker.checkNoInterleaving(), "Operations interleaved - lock is not working properly. Order: \(orderTracker.order)")

        let validPatterns = [
            [1, -1, 2, -2],  // Operation 1 completes, then operation 2
            [2, -2, 1, -1]   // Operation 2 completes, then operation 1
        ]

        let patternMatches = validPatterns.contains { orderTracker.order == $0 }
        #expect(patternMatches, "Expected a valid operation sequence. Got: \(orderTracker.order)")
    }

    @Test("FHIRResourceLockManager - Concurrent Lock Access")
    func testConcurrentLockAccess() throws {
        let identityKey = Constants.standardIdentityKey

        let orderTracker = UnsafeOrderTracker()
        let counter = UnsafeCounter()
        let iterations = Constants.iterations

        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

        for iterationStep in 0..<iterations * 2 {
            group.enter()
            queue.async {
                do {
                    let opType = (iterationStep % 2) + 1
                    try lockManager.withLock(for: identityKey) {
                        orderTracker.append(opType)
                        counter.increment(after: Constants.shortDelay)
                        orderTracker.append(-opType)
                    }
                    group.leave()
                } catch {
                    Issue.record("Lock execution failed: \(error)")
                    group.leave()
                }
            }
        }

        let timeoutResult = group.wait(timeout: .now() + Constants.longTimeout)
        #expect(timeoutResult == .success, "Operations timed out")

        #expect(counter.value == iterations * 2, "With proper locking, counter should be \(iterations * 2) but got \(counter.value)")

        #expect(orderTracker.checkNoInterleaving(), "Operations interleaved - lock is not working properly")
    }

    // swiftlint:disable function_body_length
    @Test("FHIRResourceLockManager - Multiple Distinct Locks")
    func testMultipleDistinctLocks() throws {
        let identityKeys = Constants.multipleIdentityKeys

        let trackers: [String: UnsafeKeyAwareOrderTracker] = {
            var result = [String: UnsafeKeyAwareOrderTracker]()
            for key in identityKeys {
                result[key] = UnsafeKeyAwareOrderTracker()
            }
            return result
        }()

        let counters: [String: UnsafeCounter] = {
            var result = [String: UnsafeCounter]()
            for key in identityKeys {
                result[key] = UnsafeCounter()
            }
            return result
        }()

        let totalKey = "global-counter"
        let totalCounter = UnsafeCounter()

        let iterations = Constants.iterations
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

        for identityKey in identityKeys {
            guard let tracker = trackers[identityKey],
                  let counter = counters[identityKey] else {
                Issue.record("Missing tracker or counter for key: \(identityKey)")
                return
            }

            for iterationStep in 0..<iterations * 2 {
                group.enter()
                queue.async {
                    do {
                        let opType = (iterationStep % 2) + 1
                        try lockManager.withLock(for: identityKey) {
                            tracker.append(key: identityKey, opType: opType)
                            counter.increment(after: Constants.shortDelay)
                            tracker.append(key: identityKey, opType: -opType)
                        }

                        try lockManager.withLock(for: totalKey) {
                            totalCounter.increment()
                        }

                        group.leave()
                    } catch {
                        Issue.record("Lock execution failed: \(error)")
                        group.leave()
                    }
                }
            }
        }

        let timeoutResult = group.wait(timeout: .now() + Constants.longTimeout)
        #expect(timeoutResult == .success, "Operations timed out")

        for key in identityKeys {
            guard let counter = counters[key] else {
                Issue.record("Missing counter for key: \(key)")
                continue
            }

            let expectedKeyOperations = iterations * 2
            #expect(counter.value == expectedKeyOperations, "Expected \(expectedKeyOperations) operations for key \(key) but got \(counter.value)")
        }

        let expectedTotal = identityKeys.count * iterations * 2
        #expect(totalCounter.value == expectedTotal, "Expected \(expectedTotal) total operations but got \(totalCounter.value)")

        for key in identityKeys {
            guard let tracker = trackers[key] else {
                Issue.record("Missing tracker for key: \(key)")
                continue
            }

            #expect(tracker.checkNoInterleavingPerKey(), "Operations with key \(key) interleaved - lock is not working properly")
        }
    }
}

extension FHIRResourceLockManagerTests {
    class UnsafeCounter: @unchecked Sendable {
        var value = 0

        func increment(after delay: TimeInterval? = nil) {
            let current = value
            if let delay {
                Thread.sleep(forTimeInterval: delay)
            }
            value = current + 1
        }
    }

    class UnsafeOrderTracker: @unchecked Sendable {
        var order = [Int]()

        func append(_ value: Int) {
            order.append(value)
        }

        func checkNoInterleaving() -> Bool {
            var activeOp: Int?

            for entry in order {
                if entry > 0 {
                    // If another operation is already active, we have interleaving
                    if activeOp != nil {
                        return false
                    }
                    activeOp = entry
                } else {
                    // Should match the active operation
                    if activeOp != abs(entry) {
                        return false
                    }
                    activeOp = nil
                }
            }

            return true
        }
    }

    class UnsafeKeyAwareOrderTracker: @unchecked Sendable {
        var operations = [(key: String, opType: Int)]()

        private var activeOps = [String: Int]()

        func append(key: String, opType: Int) {
            operations.append((key: key, opType: opType))

            if opType > 0 {
                activeOps[key] = opType
            } else {
                activeOps[key] = nil
            }
        }

        func checkNoInterleavingPerKey() -> Bool {
            var activeOperationsByKey = [String: Int]()

            for operation in operations {
                let key = operation.key
                let opType = operation.opType

                if opType > 0 {
                    // If we already have an active operation for this key, that's interleaving
                    if activeOperationsByKey[key] != nil {
                        return false
                    }
                    activeOperationsByKey[key] = opType
                } else {
                    // Should match an active operation for this key
                    if activeOperationsByKey[key] != abs(opType) {
                        return false
                    }
                    activeOperationsByKey[key] = nil
                }
            }

            return true
        }
    }
}
