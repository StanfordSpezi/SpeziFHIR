//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import enum ModelsR4.ResourceProxy
import enum ModelsDSTU2.ResourceProxy


// swiftlint:disable file_length
// We disable the file length here to ensure that we cover all switch cases explicitly.
extension FHIRResource {
    /// Enum representing different categories of FHIR resources.
    /// This categorization helps in classifying FHIR resources into common healthcare scenarios and types.
    enum FHIRResourceCategory: CaseIterable {
        /// Represents an observation-type resource (e.g., patient measurements, lab results).
        case observation
        /// Represents an encounter-type resource (e.g., patient visits, admissions).
        case encounter
        ///  Represents a condition-type resource (e.g., diagnoses, patient conditions).
        case condition
        /// Represents a diagnostic-type resource (e.g., radiology, pathology reports).
        case diagnostic
        /// Represents a procedure-type resource (e.g., surgical procedures, therapies).
        case procedure
        /// Represents an immunization-type resource (e.g., vaccine administrations).
        case immunization
        /// Represents an allergy or intolerance-type resource.
        case allergyIntolerance
        /// Represents a medication-type resource (e.g., prescriptions, medication administrations).
        case medication
        /// Represents other types of resources not covered by the above categories.
        case other


        /// The ``FHIRStore`` property key path of the resource.
        ///
        /// - Note: Needs to be isolated on `MainActor` as the respective ``FHIRStore`` properties referred to by the `KeyPath` are isolated on the `MainActor`.
        @MainActor var storeKeyPath: KeyPath<FHIRStore, [FHIRResource]> {
            switch self {
            case .observation: \.observations
            case .encounter: \.encounters
            case .condition: \.conditions
            case .diagnostic: \.diagnostics
            case .procedure: \.procedures
            case .immunization: \.immunizations
            case .allergyIntolerance: \.allergyIntolerances
            case .medication: \.medications
            case .other: \.otherResources
            }
        }
    }
    

    /// Category of the FHIR resource.
    ///
    /// Analyzes the type of the underlying resource and assigns it to an appropriate category.
    var category: FHIRResourceCategory {
        switch versionedResource {
        case let .r4(resource):
            switch ResourceProxy(with: resource) {
            case .allergyIntolerance:
                return .allergyIntolerance
            case .condition:
                return .condition
            case .diagnosticReport:
                return .diagnostic
            case .encounter:
                return .encounter
            case .immunization,
                .immunizationEvaluation,
                .immunizationRecommendation:
                return .immunization
            case .medication,
                .medicationAdministration,
                .medicationDispense,
                .medicationKnowledge,
                .medicationRequest,
                .medicationStatement:
                return .medication
            case .observation,
                .observationDefinition:
                return .observation
            case .procedure:
                return .procedure
            default:
                return .other
            }
        case let .dstu2(resource):
            switch ResourceProxy(with: resource) {
            case .allergyIntolerance:
                return .allergyIntolerance
            case .condition:
                return .condition
            case .diagnosticOrder,
                .diagnosticReport:
                return .diagnostic
            case .encounter:
                return .encounter
            case .immunization,
                .immunizationRecommendation:
                return .immunization
            case .medication,
                .medicationAdministration,
                .medicationDispense,
                .medicationOrder,
                .medicationStatement:
                return .medication
            case .observation:
                return .observation
            case .procedure,
                .procedureRequest:
                return .procedure
            default:
                return .other
            }
        }
    }
}
