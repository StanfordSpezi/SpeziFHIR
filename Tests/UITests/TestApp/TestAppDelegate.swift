//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziHealthKit


class TestAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: TestingStandard()) {
            HealthKit {
                let recordTypes: [SampleType<HKClinicalRecord>] = [
                    .allergyRecord, .clinicalNoteRecord, .conditionRecord,
                    .coverageRecord, .immunizationRecord, .labResultRecord,
                    .medicationRecord, .procedureRecord, .vitalSignRecord
                ]
                for recordType in recordTypes {
                    CollectSample(recordType)
                }
            }
        }
    }
}
