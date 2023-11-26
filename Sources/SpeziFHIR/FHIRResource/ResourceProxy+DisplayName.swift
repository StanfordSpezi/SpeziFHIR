//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4


extension ResourceProxy {
    /// Provides a best-effort human readable display name for the resource.
    public var displayName: String {
        switch self {
        case let .condition(condition):
            return condition.code?.text?.value?.string ?? resourceType
        case let .diagnosticReport(diagnosticReport):
            return diagnosticReport.code.coding?.first?.display?.value?.string ?? resourceType
        case let .encounter(encounter):
            return encounter.reasonCode?.first?.coding?.first?.display?.value?.string
                ?? encounter.type?.first?.coding?.first?.display?.value?.string
                ?? resourceType
        case let .immunization(immunization):
            return immunization.vaccineCode.text?.value?.string ?? resourceType
        case let .medicationRequest(medicationRequest):
            guard case let .codeableConcept(medicationCodeableConcept) = medicationRequest.medication else {
                return resourceType
            }
            return medicationCodeableConcept.text?.value?.string ?? resourceType
        case let .observation(observation):
            return observation.code.text?.value?.string ?? resourceType
        case let .procedure(procedure):
            return procedure.code?.text?.value?.string ?? resourceType
        case let .patient(patient):
            let name = (patient.name?.first?.given?.first?.value?.string ?? "") + (patient.name?.first?.family?.value?.string ?? "")
            guard !name.isEmpty else {
                return resourceType
            }
            return name
        default:
            return resourceType
        }
    }
}
