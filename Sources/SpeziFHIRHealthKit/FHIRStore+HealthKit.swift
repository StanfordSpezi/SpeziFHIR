//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import HealthKitOnFHIR
import ModelsDSTU2
import ModelsR4
import SpeziFHIR
import SpeziHealthKit


extension FHIRStore {
    private static let hkHealthStore: HKHealthStore? = {
        guard HKHealthStore.isHealthDataAvailable() else {
            return nil
        }
        
        return HKHealthStore()
    }()
    
    
    /// Add a HealthKit sample to the FHIR store.
    /// - Parameter sample: The sample that should be added.
    public func add(sample: HKSample) async {
        do {
            let resource = try await transform(sample: sample)
            insert(resource: resource)
        } catch {
            print("Could not transform HKSample: \(error)")
        }
    }
    
    /// Remove a HealthKit sample delete object from the FHIR store.
    /// - Parameter sample: The sample delete object that should be removed.
    public func remove(sample: HKDeletedObject) async {
        remove(resource: sample.uuid.uuidString)
    }
    
    
    private func transform(sample: HKSample) async throws -> FHIRResource {
        switch sample {
        case let clinicalResource as HKClinicalRecord where clinicalResource.fhirResource?.fhirVersion == .primaryDSTU2():
            guard let fhirResource = clinicalResource.fhirResource else {
                throw HealthKitOnFHIRError.invalidFHIRResource
            }
            
            let decoder = JSONDecoder()
            let resourceProxy = try decoder.decode(ModelsDSTU2.ResourceProxy.self, from: fhirResource.data)
            
            return FHIRResource(
                versionedResource: .dstu2(resourceProxy.get()),
                displayName: clinicalResource.displayName
            )
        case let electrocardiogram as HKElectrocardiogram:
            guard let hkHealthStore = Self.hkHealthStore else {
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
