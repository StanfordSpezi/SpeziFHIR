//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import ModelsR4


extension Questionnaire {
    /// Get ValueSets defined as a contained resource within a FHIR `Questionnaire`
    /// - Returns: An array of `ValueSet`
    public func getContainedValueSets() -> [ValueSet] {
        guard let contained = self.contained else {
            return []
        }
        let valueSets = contained.compactMap { resource in
            resource.get() as? ValueSet
        }
        return valueSets
    }
}
