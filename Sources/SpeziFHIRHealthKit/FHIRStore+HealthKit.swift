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
    /// - Parameters:
    ///   - sample: The sample that should be added.
    ///   - loadHealthKitAttachements: Indicates if the `HKAttachmentStore` should be queried for any document references found in clinical records.
    public func add(sample: HKSample, loadHealthKitAttachements: Bool = false) async {
        do {
            var resource = try await FHIRResource.initialize(basedOn: sample)
            if loadHealthKitAttachements, let hkHealthStore = Self.hkHealthStore {
                try await resource.loadAttachements(from: sample, store: hkHealthStore)
            }
            await insert(resource: resource)
        } catch {
            print("Could not transform HKSample: \(error)")
        }
    }
    
    /// Remove a HealthKit sample delete object from the FHIR store.
    /// - Parameter sample: The sample delete object that should be removed.
    public func remove(sample: HKDeletedObject) async {
        await remove(resource: sample.uuid.uuidString)
    }
}
