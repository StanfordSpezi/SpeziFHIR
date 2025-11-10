//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2
import ModelsR4


/// Represents a FHIR (Fast Healthcare Interoperability Resources) entity.
///
/// Handles both DSTU2 and R4 versions, providing a unified interface to interact with different FHIR versions.
public struct FHIRResource: Identifiable, Hashable {
    /// Version-specific FHIR resources.
    public enum VersionedFHIRResource: Hashable {
        /// R4 version of FHIR resources.
        case r4(ModelsR4.Resource) // swiftlint:disable:this identifier_name
        /// DSTU2 version of FHIR resources.
        case dstu2(ModelsDSTU2.Resource)
    }
    
    public struct ID: Hashable, Codable, Sendable {
        @_spi(Testing) public let fhirResourceId: String
        @_spi(Testing) public let healthKitUUID: String?
    }
    
    public static let fhirExtensionUrlHKSampleId = URL(string: "https://bdh.stanford.edu/fhir/defs/HealthKitSampleID")!
    // swiftlint:disable:previous force_unwrapping
    
    
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
        case let .r4(resource):
            (resource as? ModelsR4.DomainResource)?
                .extensions(for: Self.fhirExtensionUrlHKSampleId.absoluteString)
                .first?.value?.idString
        case let .dstu2(resource):
            (resource as? ModelsDSTU2.DomainResource)?
                .extensions(for: Self.fhirExtensionUrlHKSampleId.absoluteString)
                .first?.value?.idString
        }
    }
    
    /// The date associated with the FHIR resource, if available. This could represent different dates depending on the resource type, like issued date for observations.
    public var date: Date? {
        switch versionedResource {
        case let .r4(resource):
            switch resource {
            case let carePlan as ModelsR4.CarePlan:
                return carePlan.period?.date
            case let careTeam as ModelsR4.CareTeam:
                return careTeam.period?.date
            case let claim as ModelsR4.Claim:
                return try? claim.billablePeriod?.end?.value?.asNSDate()
            case let condition as ModelsR4.Condition:
                return condition.onset?.date
            case let device as ModelsR4.Device:
                return try? device.manufactureDate?.value?.asNSDate()
            case let diagnosticReport as ModelsR4.DiagnosticReport:
                return diagnosticReport.effective?.date
            case let documentReference as ModelsR4.DocumentReference:
                return try? documentReference.date?.value?.asNSDate()
            case let encounter as ModelsR4.Encounter:
                return try? encounter.period?.end?.value?.asNSDate()
            case let explanationOfBenefit as ModelsR4.ExplanationOfBenefit:
                return try? explanationOfBenefit.billablePeriod?.end?.value?.asNSDate()
            case let immunization as ModelsR4.Immunization:
                return immunization.occurrence.date
            case let medicationRequest as ModelsR4.MedicationRequest:
                return try? medicationRequest.authoredOn?.value?.asNSDate()
            case let medicationAdministration as ModelsR4.MedicationAdministration:
                return medicationAdministration.effective.date
            case let observation as ModelsR4.Observation:
                if let issuedDate = observation.issued {
                    return try? issuedDate.value?.asNSDate()
                } else if case let .dateTime(effectiveDate) = observation.effective {
                    return try? effectiveDate.value?.asNSDate()
                }
                return nil
            case let procedure as ModelsR4.Procedure:
                return procedure.performed?.date
            case let patient as ModelsR4.Patient:
                return try? patient.birthDate?.value?.asNSDate()
            case let provenance as ModelsR4.Provenance:
                return try? provenance.recorded.value?.asNSDate()
            case let supplyDelivery as ModelsR4.SupplyDelivery:
                return supplyDelivery.occurrence?.date
            default:
                return nil
            }
        case let .dstu2(resource):
            switch resource {
            case let observation as ModelsDSTU2.Observation:
                if let issuedDate = observation.issued {
                    return try? issuedDate.value?.asNSDate()
                } else if case let .dateTime(effectiveDate) = observation.effective {
                    return try? effectiveDate.value?.asNSDate()
                }
                return nil
            case let medicationOrder as ModelsDSTU2.MedicationOrder:
                return try? medicationOrder.dateWritten?.value?.asNSDate()
            case let medicationStatement as ModelsDSTU2.MedicationStatement:
                guard case let .dateTime(date) = medicationStatement.effective else {
                    return nil
                }
                return try? date.value?.asNSDate()
            case let condition as ModelsDSTU2.Condition:
                guard case let .dateTime(date) = condition.onset else {
                    return nil
                }
                return try? date.value?.asNSDate()
            case let procedure as ModelsDSTU2.Procedure:
                switch procedure.performed {
                case let .dateTime(date):
                    if let date = try? date.value?.asNSDate() {
                        return date
                    }
                case let .period(period):
                    if let date = try? period.end?.value?.asNSDate() {
                        return date
                    }
                default:
                    break
                }
                
                return nil
            default:
                return nil
            }
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
    
    /// Convenience initializer for R4 version of FHIR resources.
    /// - Parameters:
    ///   - resource: An R4 FHIR resource.
    ///   - displayName: A user-friendly name for the resource.
    public init(resource: ModelsR4.Resource, displayName: String) {
        self.init(versionedResource: .r4(resource), displayName: displayName)
    }
    
    /// Convenience initializer for DSTU2 version of FHIR resources.
    /// - Parameters:
    ///   - resource: A DSTU2 FHIR resource.
    ///   - displayName: A user-friendly name for the resource.
    public init(resource: ModelsDSTU2.Resource, displayName: String) {
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
