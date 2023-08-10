//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Spezi
import SpeziFHIR


/// A data storage provider that collects all uploads and displays them in a user interface using the ``RequestList``.
public actor MockWebService: Component, ObservableObjectProvider, ObservableObject {
    @MainActor @Published var requests: [Request] = []
    
    
    public init() { }
    
    
    public func upload(path: String, body: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                requests.insert(Request(type: .add, path: path, body: body), at: 0)
                continuation.resume()
            }
        }
    }
    
    public func remove(path: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                requests.insert(Request(type: .delete, path: path), at: 0)
                continuation.resume()
            }
        }
    }
}
