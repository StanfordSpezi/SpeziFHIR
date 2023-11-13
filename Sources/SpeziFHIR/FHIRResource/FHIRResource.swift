//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@preconcurrency import ModelsDSTU2
@preconcurrency import ModelsR4


public struct FHIRResource: Sendable, Identifiable, Hashable {
    public enum VersionedFHIRResource: Sendable, Hashable {
        case r4(ModelsR4.Resource) // swiftlint:disable:this identifier_name
        case dstu2(ModelsDSTU2.Resource)
    }
    
    
    public let versionedResource: VersionedFHIRResource
    public let displayName: String
    
    
    public var id: String {
        switch versionedResource {
        case let .r4(resource):
            guard let id = resource.id?.value?.string else {
                preconditionFailure(
                    "A stable identifier must be present when wrapping content in a FHIRResource. The identifier might have been changed."
                )
            }
            return id
        case let .dstu2(resource):
            guard let id = resource.id?.value?.string else {
                preconditionFailure(
                    "A stable identifier must be present when wrapping content in a FHIRResource. The identifier might have been changed."
                )
            }
            return id
        }
    }
    
    public var date: Date? {
        switch versionedResource {
        case let .r4(resource):
            switch resource {
            case let observation as ModelsR4.Observation:
                return try? observation.issued?.value?.asNSDate()
            default:
                return nil
            }
        case let .dstu2(resource):
            switch resource {
            case let observation as ModelsDSTU2.Observation:
                return try? observation.issued?.value?.asNSDate()
            case let medicationOrder as ModelsDSTU2.MedicationOrder:
                return try? medicationOrder.dateWritten?.value?.asNSDate()
            case let condition as ModelsDSTU2.MedicationOrder:
                return try? condition.dateWritten?.value?.asNSDate()
            case let procedure as ModelsDSTU2.Procedure:
                guard case let .dateTime(date) = procedure.performed else {
                    return nil
                }
                return try? date.value?.asNSDate()
            default:
                return nil
            }
        }
    }
    
    public var resourceType: String {
        switch versionedResource {
        case let .r4(resource):
            return ResourceProxy(with: resource).resourceType
        case let .dstu2(resource):
            return ResourceProxy(with: resource).resourceType
        }
    }
    
    public var jsonDescription: String {
        json(withConfiguration: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes])
    }
    
    
    public init(versionedResource: VersionedFHIRResource, displayName: String) {
        // We fail in debug builds to inform developers about the need to define identifier.
        // We fallback to generating unique ids in production builds.
        switch versionedResource {
        case let .r4(resource):
            if resource.id?.value?.string == nil {
                assertionFailure("Could not find a stable identifier for the resources. Be sure that your resouces as the `id` field set.")
                resource.id = FHIRPrimitive(stringLiteral: UUID().uuidString)
            }
        case let .dstu2(resource):
            if resource.id?.value?.string == nil {
                assertionFailure("Could not find a stable identifier for the resources. Be sure that your resouces as the `id` field set.")
                resource.id = FHIRPrimitive(stringLiteral: UUID().uuidString)
            }
        }
        
        self.versionedResource = versionedResource
        self.displayName = displayName
    }
    
    public init(resource: ModelsR4.Resource, displayName: String) {
        self.init(versionedResource: .r4(resource), displayName: displayName)
    }
    
    public init(resource: ModelsDSTU2.Resource, displayName: String) {
        self.init(versionedResource: .dstu2(resource), displayName: displayName)
    }
    
    
    public func json(withConfiguration outputFormatting: JSONEncoder.OutputFormatting) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        
        switch versionedResource {
        case let .r4(resource):
            return (try? String(decoding: encoder.encode(resource), as: UTF8.self)) ?? "{}"
        case let .dstu2(resource):
            return (try? String(decoding: encoder.encode(resource), as: UTF8.self)) ?? "{}"
        }
    }
}
