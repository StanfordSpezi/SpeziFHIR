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
    
    override var configuration: Configuration {
        Configuration(standard: TestingStandard()) {
            HealthKit {
                CollectSample(.allergyRecord, predicate: healthKitPredicate)
                CollectSample(.clinicalNoteRecord, predicate: healthKitPredicate)
                CollectSample(.conditionRecord, predicate: healthKitPredicate)
                CollectSample(.coverageRecord, predicate: healthKitPredicate)
                CollectSample(.immunizationRecord, predicate: healthKitPredicate)
                CollectSample(.labResultRecord, predicate: healthKitPredicate)
                CollectSample(.medicationRecord, predicate: healthKitPredicate)
                CollectSample(.procedureRecord, predicate: healthKitPredicate)
                CollectSample(.vitalSignRecord, predicate: healthKitPredicate)
            }
        }
    }
}
