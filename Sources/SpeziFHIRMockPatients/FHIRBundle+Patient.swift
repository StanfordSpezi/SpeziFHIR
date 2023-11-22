//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import class ModelsR4.Bundle
import class ModelsR4.Patient


extension ModelsR4.Bundle {
    var patient: Patient? {
        entry?.compactMap { $0.resource?.get(if: ModelsR4.Patient.self) }.first
    }
    
    var patientName: String {
        guard let patient = patient,
              let name = patient.name?.first,
              let givenName = name.given?.first?.value?.string,
              let familyName = name.family?.value?.string else {
            return String(localized: "Unknown Patient", bundle: .module)
        }
        
        return givenName + " " + familyName
    }
}
