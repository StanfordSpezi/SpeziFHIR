//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import os
import Spezi
import SpeziFHIR
//import SpeziHealthKit
//import SpeziHealthKitFHIR


actor TestingStandard: Standard, EnvironmentAccessible {
    static let recordTypes: [HKClinicalType] = [
        HKClinicalType(.allergyRecord), HKClinicalType(.clinicalNoteRecord), HKClinicalType(.conditionRecord),
        HKClinicalType(.coverageRecord), HKClinicalType(.immunizationRecord), HKClinicalType(.labResultRecord),
        HKClinicalType(.medicationRecord), HKClinicalType(.procedureRecord), HKClinicalType(.vitalSignRecord)
    ]
    
    @Dependency(FHIRStore.self) private var fhirStore
//    @Dependency(HealthKit.self) private var healthKit
    
    private let logger = Logger()
//    private var useHealthKitResources = true
    private var samples: [HKSample] = []
    
    @MainActor
    func configure() {
//        Task {
//            await self.initialSetup()
//        }
    }
    
//    private func initialSetup() async {
//        guard useHealthKitResources else {
//            return
//        }
//        await healthKit.waitForConfigurationDone()
//        guard healthKit.isFullyAuthorized else {
//            logger.error("HealthKit permissions not yet provided.")
//            return
//        }
//        await fetchRecordsFromHealthKit()
//    }
    
    
//    func fetchRecordsFromHealthKit() async {
//        guard useHealthKitResources else {
//            return
//        }
//        await fhirStore.removeAllResources()
//        let healthKit = self.healthKit
//        await withTaskGroup { taskGroup in
//            for recordType in Self.recordTypes {
//                taskGroup.addTask { [self] in
//                    let records = try? await healthKit.query(
//                        recordType,
//                        timeRange: .ever,
//                        sortedBy: [SortDescriptor(\.startDate, order: .reverse)]
//                    )
//                    guard let records else {
//                        return
//                    }
//                    await addRecords(records)
//                }
//            }
//        }
//    }
    
//    private func addRecords(_ records: [HKClinicalRecord]) async {
//        await withTaskGroup { sampleTaskGroup in
//            for newHealthKitSample in records {
//                sampleTaskGroup.addTask { [self] in
//                    do {
//                        try await fhirStore.add(newHealthKitSample, using: /*healthKit*/ nil, loadHealthKitAttachments: true)
//                    } catch {
//                        logger.error("Could not transform sample \(newHealthKitSample.id) to FHIR resource: \(error)")
//                    }
//                }
//            }
//        }
//    }
}


//extension TestingStandard: HealthKitConstraint {
//    func handleNewSamples<Sample>(_ addedSamples: some Collection<Sample>, ofType sampleType: SampleType<Sample>) async {
//        samples.append(contentsOf: addedSamples.lazy.map { $0 as HKSample })
//        if useHealthKitResources {
//            for sample in addedSamples {
//                do {
//                    try await fhirStore.add(sample, using: healthKit)
//                } catch {
//                    logger.error("Cloud not transform HealthKit sample with id: \(sample.id)")
//                }
//            }
//        }
//    }
//    
//    func handleDeletedObjects<Sample>(_ deletedObjects: some Collection<HKDeletedObject>, ofType sampleType: SampleType<Sample>) async {
//        for object in deletedObjects {
//            samples.removeAll { $0.id == object.uuid }
//            if useHealthKitResources {
//                await fhirStore.remove(object)
//            }
//        }
//    }
//}
