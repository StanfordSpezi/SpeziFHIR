//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2
import ModelsR4


extension FHIRResource {
    private static let encoder = PropertyListEncoder()

    private static let decoder = PropertyListDecoder()

    private static let lockManager = FHIRResourceLockManager()

    private var resourceIdentityKey: String {
        let resourceId: String

        switch versionedResource {
        case .r4(let r4Resource):
            resourceId = r4Resource.id?.value?.string ?? UUID().uuidString
        case .dstu2(let dstu2Resource):
            resourceId = dstu2Resource.id?.value?.string ?? UUID().uuidString
        }

        let resourceType = String(describing: type(of: versionedResource))
        return "\(resourceType)_\(resourceId)"
    }

    /// Creates a thread-safe deep copy of the FHIR resource using per-resource locking.
    ///
    /// This implementation uses a unique lock for each resource identity, allowing multiple
    /// different resources to be copied concurrently.
    ///
    /// - Returns: A deep copy of this FHIR resource with identical content but separate memory allocation
    /// - Throws: An error if JSON serialization or deserialization fails
    ///
    /// - Warning: While thread-safe, this method is still computationally expensive.
    ///            Consider using it only when creating a new copy is strictly necessary.
    public func copy() throws -> Self {
        let localVersionedResource = versionedResource
        let localDisplayName = displayName

        let identityKey = resourceIdentityKey

        return try Self.lockManager.withLock(for: identityKey) {
            switch localVersionedResource {
            case let .r4(r4Resource):
                let encodedData = try Self.encoder.encode(r4Resource)
                let resource = try Self.decoder.decode(ModelsR4.ResourceProxy.self, from: encodedData).get()
                return .init(resource: resource, displayName: localDisplayName)

            case let .dstu2(dstu2Resource):
                let encodedData = try Self.encoder.encode(dstu2Resource)
                let resource = try Self.decoder.decode(ModelsDSTU2.ResourceProxy.self, from: encodedData).get()
                return .init(resource: resource, displayName: localDisplayName)
            }
        }
    }
}
