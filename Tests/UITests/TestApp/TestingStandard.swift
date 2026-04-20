//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import Spezi
import SpeziFHIR


actor TestingStandard: Standard, EnvironmentAccessible {
    static let recordTypes: [HKClinicalType] = [
        HKClinicalType(.allergyRecord), HKClinicalType(.clinicalNoteRecord), HKClinicalType(.conditionRecord),
        HKClinicalType(.coverageRecord), HKClinicalType(.immunizationRecord), HKClinicalType(.labResultRecord),
        HKClinicalType(.medicationRecord), HKClinicalType(.procedureRecord), HKClinicalType(.vitalSignRecord)
    ]
    
    @Dependency(FHIRStore.self) private var fhirStore
}
