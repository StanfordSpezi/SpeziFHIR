//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import HealthKitOnFHIR
import ModelsDSTU2
import ModelsR4
import SpeziFHIR
import SpeziHealthKit


extension FHIRResource {
    /// Creates a new ``FHIRResource`` instance using an `HKSample`.
    /// - Parameters:
    ///   - sample: The sample that should be transformed in a ``FHIRResource``.
    ///   - healthKit: Optional `HealthKit` module used to query additional context such as symptoms and voltage measurements for electrocardiograms and attachements for clinical records.
    ///   - loadHealthKitAttachements: Indicates if the `HKAttachmentStore` should be queried for any document references found in clinical records.
    /// - Returns: Created ``FHIRResource`` instance.
    public static func initialize(
        basedOn sample: HKSample,
        using healthKit: HealthKit? = nil,
        loadHealthKitAttachements: Bool = false
    ) async throws -> FHIRResource {
        switch sample {
        case let clinicalResource as HKClinicalRecord where clinicalResource.fhirResource?.fhirVersion == .primaryDSTU2():
            guard let fhirResource = clinicalResource.fhirResource else {
                throw HealthKitOnFHIRError.invalidFHIRResource
            }
            
            let decoder = JSONDecoder()
            let resourceProxy = try decoder.decode(ModelsDSTU2.ResourceProxy.self, from: fhirResource.data)
            let fhirModelResource = resourceProxy.get()
            
            var resource = FHIRResource(
                versionedResource: .dstu2(fhirModelResource),
                displayName: clinicalResource.displayName
            )
            if loadHealthKitAttachements, let healthKit = healthKit {
                try await resource.loadAttachements(for: sample, using: healthKit)
            }
            return resource
        case let clinicalResource as HKClinicalRecord:
            let fhirModelResource = try clinicalResource.resource().get()
            
            var resource = FHIRResource(
                versionedResource: .r4(fhirModelResource),
                displayName: clinicalResource.displayName
            )
            if loadHealthKitAttachements, let healthKit = healthKit {
                try await resource.loadAttachements(for: sample, using: healthKit)
            }
            return resource
        case let electrocardiogram as HKElectrocardiogram:
            guard let healthKit = healthKit else {
                fallthrough
            }
            
            async let symptoms = try electrocardiogram.symptoms(from: healthKit)
            async let voltageMeasurements = try electrocardiogram.voltageMeasurements(from: healthKit.healthStore)
            
            let electrocardiogramResource = try await electrocardiogram.observation(
                symptoms: symptoms,
                voltageMeasurements: voltageMeasurements.map { ($0.timeOffset, $0.voltage) }
            )
            return FHIRResource(
                versionedResource: .r4(electrocardiogramResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(electrocardiogramResource.id?.value?.string ?? "-")")
            )
        default:
            let genericResource = try sample.resource().get()
            return FHIRResource(
                versionedResource: .r4(genericResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(genericResource.id?.value?.string ?? "-")")
            )
        }
    }
}
