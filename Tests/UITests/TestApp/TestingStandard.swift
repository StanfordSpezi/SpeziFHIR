//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIR
import SpeziFHIRHealthKit
import SpeziHealthKit


actor TestingStandard: Standard, HealthKitConstraint, EnvironmentAccessible {
    @Model private(set) var fhirStore = FHIRStore()
    
    private var useHealthKitResources = true
    private var samples: [HKSample] = []
    
    
    func add(sample: HKSample) async {
        samples.append(sample)
        if useHealthKitResources {
            await fhirStore.add(sample: sample)
        }
    }
    
    func remove(sample: HKDeletedObject) async {
        samples.removeAll(where: { $0.id == sample.uuid })
        if useHealthKitResources {
            await fhirStore.remove(sample: sample)
        }
    }
    
    func loadHealthKitResources() async {
        await MainActor.run {
            FHIRStore.loadHealthKitAttachements = true
        }
        await fhirStore.removeAllResources()
        
        for sample in samples {
            await fhirStore.add(sample: sample)
        }
        
        useHealthKitResources = true
    }
}
