//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order

public import FHIRModelsExtensions
public import Foundation
public import ModelsDSTU2
public import ModelsR4


extension FHIRExtensionURL {
    /// The resource's associated HealthKit HKSample identifier, if applicable.
    public static let hkSampleId = Self("https://bdh.stanford.edu/fhir/defs/HealthKitSampleID")
}

/// Represents a FHIR (Fast Healthcare Interoperability Resources) entity.
///
/// Handles both DSTU2 and R4 versions, providing a unified interface to interact with different FHIR versions.
public struct FHIRResource: Identifiable, Hashable, Sendable {
    /// Version-specific FHIR resources.
    public enum VersionedFHIRResource: Hashable, Sendable {
        /// R4 version of FHIR resources.
        case r4(any ModelsR4.Resource) // swiftlint:disable:this identifier_name
        /// DSTU2 version of FHIR resources.
        case dstu2(any ModelsDSTU2.Resource)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.r4(lhs), .r4(rhs)):
                lhs.isEqual(rhs)
            case let (.dstu2(lhs), .dstu2(rhs)):
                lhs.isEqual(rhs)
            case (.r4, .dstu2), (.dstu2, .r4):
                false
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .r4(let resource):
                hasher.combine(0)
                resource.hash(into: &hasher)
            case .dstu2(let resource):
                hasher.combine(1)
                resource.hash(into: &hasher)
            }
        }
    }
    
    public struct ID: Hashable, Codable, Sendable {
        @_spi(Testing) public let fhirResourceId: String
        @_spi(Testing) public let healthKitUUID: String?
    }
    
    
    /// The version-specific FHIR resource.
    public let versionedResource: VersionedFHIRResource
    /// Human-readable name or description of the resource.
    public let displayName: String
    
    
    public var id: ID {
        guard let fhirId else {
            preconditionFailure(
                "A stable identifier must be present when wrapping content in a FHIRResource. The identifier might have been changed."
            )
        }
        return ID(fhirResourceId: fhirId, healthKitUUID: healthKitSampleId)
    }
    
    /// The `id` of the underlying FHIR `Resource`.
    public var fhirId: String? {
        switch versionedResource {
        case let .r4(resource):
            resource.id?.value?.string
        case let .dstu2(resource):
            resource.id?.value?.string
        }
    }
    
    /// The `uuid` of the `HKSample` from which this FHIRResource was created, if applicable.
    var healthKitSampleId: String? {
        switch versionedResource {
        case .r4(let resource):
            return (resource as? any ModelsR4.DomainResource)?
                .extensions(for: .hkSampleId)
                .first?.value?.idString
        case .dstu2(let resource):
            return (resource as? any ModelsDSTU2.DomainResource)?
                .extensions(for: FHIRExtensionURL.hkSampleId.url.absoluteString)
                .first?.value?.idString
        }
    }
    
    /// The type of the FHIR resource represented as a string. It provides an easy way to identify the kind of FHIR entity (e.g., Observation, MedicationOrder).
    public var resourceType: String {
        switch versionedResource {
        case let .r4(resource):
            return ResourceProxy(with: resource).resourceType
        case let .dstu2(resource):
            return ResourceProxy(with: resource).resourceType
        }
    }
    
    /// JSON representation of the FHIR resource with specified formatting. Useful for serialization and debugging.
    public var jsonDescription: String {
        json(withConfiguration: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes])
    }
    
    
    /// Initializes a `FHIRResource` with a versioned FHIR resource and a display name.
    /// - Parameters:
    ///   - versionedResource: The specific version (DSTU2 or R4) of the FHIR resource.
    ///   - displayName: A user-friendly name for the resource.
    public init(versionedResource: VersionedFHIRResource, displayName: String) {
        // We fail in debug builds to inform developers about the need to define identifier.
        // We fallback to generating unique ids in production builds.
        var versionedResource = versionedResource
        switch versionedResource {
        case .r4(var resource):
            if resource.id?.value?.string == nil {
                assertionFailure("Could not find a stable identifier for the resources. Be sure that your resouces as the `id` field set.")
                resource.id = FHIRPrimitive(stringLiteral: UUID().uuidString)
                versionedResource = .r4(resource)
            }
        case .dstu2(var resource):
            if resource.id?.value?.string == nil {
                assertionFailure("Could not find a stable identifier for the resources. Be sure that your resouces as the `id` field set.")
                resource.id = FHIRPrimitive(stringLiteral: UUID().uuidString)
                versionedResource = .dstu2(resource)
            }
        }
        self.versionedResource = versionedResource
        self.displayName = displayName
    }
    
    /// Convenience initializer for R4 version of FHIR resources.
    /// - Parameters:
    ///   - resource: An R4 FHIR resource.
    ///   - displayName: A user-friendly name for the resource.
    public init(resource: any ModelsR4.Resource, displayName: String) {
        self.init(versionedResource: .r4(resource), displayName: displayName)
    }
    
    /// Convenience initializer for DSTU2 version of FHIR resources.
    /// - Parameters:
    ///   - resource: A DSTU2 FHIR resource.
    ///   - displayName: A user-friendly name for the resource.
    public init(resource: any ModelsDSTU2.Resource, displayName: String) {
        self.init(versionedResource: .dstu2(resource), displayName: displayName)
    }
    
    
    /// Generates a JSON string representation of the resource with specified formatting options.
    /// - Parameter outputFormatting: JSON encoding options such as pretty printing.
    /// - Returns: A JSON string representing the resource.
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


extension FHIRResource {
    /// The underlying R4 resource, if applicable
    public var r4: (any ModelsR4.Resource)? { // swiftlint:disable:this identifier_name
        switch versionedResource {
        case .r4(let resource):
            resource
        case .dstu2:
            nil
        }
    }
    
    /// The underlying DSTU2 resource, if applicable
    public var dstu2: (any ModelsDSTU2.Resource)? {
        switch versionedResource {
        case .dstu2(let resource):
            resource
        case .r4:
            nil
        }
    }
}


extension ModelsDSTU2.Extension.ValueX {
    fileprivate var idString: String? {
        switch self {
        case .id(let value):
            value.value?.string
        default:
            nil
        }
    }
}

extension ModelsR4.Extension.ValueX {
    fileprivate var idString: String? {
        switch self {
        case .id(let value):
            value.value?.string
        default:
            nil
        }
    }
}


extension Equatable {
    fileprivate func isEqual(_ other: Any) -> Bool {
        if let other = other as? Self {
            self == other
        } else {
            false
        }
    }
}
