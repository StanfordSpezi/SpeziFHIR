//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import os
import Spezi
import SpeziFHIR
import SpeziFHIRHealthKit
import SpeziHealthKit


actor TestingStandard: Standard, HealthKitConstraint, EnvironmentAccessible {
    @Model private(set) var fhirStore = FHIRStore()
    
    private let logger = Logger()
    private var useHealthKitResources = true
    private var samples: [HKSample] = []
    
    func handleNewSamples<Sample>(_ addedSamples: some Collection<Sample>, ofType sampleType: SampleType<Sample>) async {
        samples.append(contentsOf: addedSamples.lazy.map { $0 as HKSample })
        if useHealthKitResources {
            for sample in addedSamples {
                do {
                    try await fhirStore.add(sample: sample)
                } catch {
                    logger.error("Cloud not transform HealthKit sample with id: \(sample.id)")
                }
            }
        }
    }
    
    func handleDeletedObjects<Sample>(_ deletedObjects: some Collection<HKDeletedObject>, ofType sampleType: SampleType<Sample>) async {
        for object in deletedObjects {
            samples.removeAll { $0.id == object.uuid }
            if useHealthKitResources {
                await fhirStore.remove(sample: object)
            }
        }
    }
    
    func loadHealthKitResources() async {
        await fhirStore.removeAllResources()
        
        for sample in samples {
            do {
                try await fhirStore.add(sample: sample, loadHealthKitAttachements: true)
            } catch {
                logger.error("Cloud not transform HealthKit sample with id: \(sample.id)")
            }
        }
        
        useHealthKitResources = true
    }
}
