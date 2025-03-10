//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIR
import SpeziHealthKit
import SwiftUI


class TestAppDelegate: SpeziAppDelegate {
    private var healthKitPredicate: NSPredicate {
        HKQuery.predicateForSamples(
            withStart: Date.distantPast,
            end: nil,
            options: .strictEndDate
        )
    }
    
    private var deliverySetting: HealthKitDeliverySetting {
        .anchorQuery(saveAnchor: false)
    }
    
    override var configuration: Configuration {
        Configuration(standard: TestingStandard()) {
            HealthKit {
                CollectSample(HKClinicalType(.allergyRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.clinicalNoteRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.conditionRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.coverageRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.immunizationRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.labResultRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.medicationRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.procedureRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
                CollectSample(HKClinicalType(.vitalSignRecord), predicate: healthKitPredicate, deliverySetting: deliverySetting)
            }
        }
    }
}
