//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@testable import SpeziFHIR
import SpeziFoundation
import Testing


@Suite
struct FHIRResourceLockManagerTests {
    private enum Constants {
        static let iterations = 100
        static let iterationDelay = 0.001
        static let operationDelay = 0.001
    }
    
    
    private let lockManager = FHIRResourceLockManager()
    
    
    @Test("FHIRResourceLockManager - Lock Protection Test")
    func testLockProtection() async throws {
        let identityKey = "testLockProtection"
        let orderTracker = UnsafeOrderTracker()
        let counter = UnsafeCounter()

        try await withThrowingTaskGroup(of: Void.self) { group in
            // Add first task
            group.addTask {
                do {
                    try self.lockManager.withLock(for: identityKey) {
                        orderTracker.append(1)
                        counter.increment(after: Constants.operationDelay)
                        orderTracker.append(-1)
                    }
                } catch {
                    Issue.record("Lock execution failed: \(error)")
                    throw error
                }
            }

            // Add second task
            group.addTask {
                do {
                    try self.lockManager.withLock(for: identityKey) {
                        orderTracker.append(2)
                        counter.increment(after: Constants.operationDelay)
                        orderTracker.append(-2)
                    }
                } catch {
                    Issue.record("Lock execution failed: \(error)")
                    throw error
                }
            }

            try await group.waitForAll()
        }

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
    func testConcurrentLockAccess() async throws {
        let identityKey = "testConcurrentLockAccess"
        let orderTracker = UnsafeOrderTracker()
        let counter = UnsafeCounter()
        let iterationsFactor = 2
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for iterationStep in 0..<Constants.iterations * iterationsFactor {
                group.addTask {
                    do {
                        let opType = (iterationStep % 2) + 1
                        try self.lockManager.withLock(for: identityKey) {
                            orderTracker.append(opType)
                            counter.increment(after: Constants.iterationDelay)
                            orderTracker.append(-opType)
                        }
                    } catch {
                        Issue.record("Lock execution failed: \(error)")
                        throw error
                    }
                }
            }
            try await group.waitForAll()
        }
        
        #expect(counter.value == Constants.iterations * iterationsFactor, "With proper locking, counter should be \(Constants.iterations * iterationsFactor) but got \(counter.value)")
        #expect(orderTracker.checkNoInterleaving(), "Operations interleaved - lock is not working properly")
    }

    // swiftlint:disable function_body_length
    @Test("FHIRResourceLockManager - Multiple Distinct Locks")
    func testMultipleDistinctLocks() async throws {
        let totalIdentityKey = "testMultipleDistinctLocks"
        let identityKeys = [
            "test-resource-1",
            "test-resource-2",
            "test-resource-3",
            "test-resource-4",
            "test-resource-5"
        ]
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
        let totalCounter = UnsafeCounter()
        let iterationsFactor = 2
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for identityKey in identityKeys {
                guard let tracker = trackers[identityKey],
                      let counter = counters[identityKey] else {
                    Issue.record("Missing tracker or counter for key: \(identityKey)")
                    return
                }

                for iterationStep in 0..<Constants.iterations * iterationsFactor {
                    group.addTask {
                        do {
                            let opType = (iterationStep % 2) + 1
                            try self.lockManager.withLock(for: identityKey) {
                                tracker.append(key: identityKey, opType: opType)
                                counter.increment(after: Constants.iterationDelay)
                                tracker.append(key: identityKey, opType: -opType)
                            }

                            try self.lockManager.withLock(for: totalIdentityKey) {
                                totalCounter.increment()
                            }
                        } catch {
                            Issue.record("Lock execution failed: \(error)")
                            throw error
                        }
                    }
                }
            }
            
            try await group.waitForAll()
        }

        for key in identityKeys {
            guard let counter = counters[key] else {
                Issue.record("Missing counter for key: \(key)")
                continue
            }

            let expectedKeyOperations = Constants.iterations * iterationsFactor
            #expect(counter.value == expectedKeyOperations, "Expected \(expectedKeyOperations) operations for key \(key) but got \(counter.value)")
        }

        let expectedTotal = identityKeys.count * Constants.iterations * iterationsFactor
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
