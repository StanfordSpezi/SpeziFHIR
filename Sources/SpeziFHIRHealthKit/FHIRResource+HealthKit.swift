//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import HealthKitOnFHIR
import ModelsDSTU2
import ModelsR4
import SpeziFHIR


extension FHIRResource {
    /// Creates a new ``FHIRResource`` instance using an `HKSample`.
    /// - Parameters:
    ///   - sample: The sample that should be transformed in a ``FHIRResource``.
    ///   - hkHealthStore: Optional `HKHealthStore` used to query additional context such as symptoms and voltage measurements for electrocardiograms. Set to nil to avoid this behavior.
    /// - Returns: Created ``FHIRResource`` instance.
     public static func initialize(
        basedOn sample: HKSample,
        hkHealthStore: HKHealthStore? = HKHealthStore()
    ) async throws -> FHIRResource {
        switch sample {
        case let clinicalResource as HKClinicalRecord where clinicalResource.fhirResource?.fhirVersion == .primaryDSTU2():
            guard let fhirResource = clinicalResource.fhirResource else {
                throw HealthKitOnFHIRError.invalidFHIRResource
            }
            
            let decoder = JSONDecoder()
            let resourceProxy = try decoder.decode(ModelsDSTU2.ResourceProxy.self, from: fhirResource.data)
            let fhirModelResource = resourceProxy.get()
            
            return FHIRResource(
                versionedResource: .dstu2(fhirModelResource),
                displayName: clinicalResource.displayName
            )
        case let clinicalResource as HKClinicalRecord:
            let fhirModelResource = try clinicalResource.resource.get()
            
            return FHIRResource(
                versionedResource: .r4(fhirModelResource),
                displayName: clinicalResource.displayName
            )
        case let electrocardiogram as HKElectrocardiogram:
            guard let hkHealthStore = hkHealthStore else {
                fallthrough
            }
            
            async let symptoms = try electrocardiogram.symptoms(from: hkHealthStore)
            async let voltageMeasurements = try electrocardiogram.voltageMeasurements(from: hkHealthStore)
            
            let electrocardiogramResource = try await electrocardiogram.observation(
                symptoms: symptoms,
                voltageMeasurements: voltageMeasurements
            )
            return FHIRResource(
                versionedResource: .r4(electrocardiogramResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(electrocardiogramResource.id?.value?.string ?? "-")")
            )
        default:
            let genericResource = try sample.resource.get()
            return FHIRResource(
                versionedResource: .r4(genericResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(genericResource.id?.value?.string ?? "-")")
            )
        }
    }
}
