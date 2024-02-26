//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SpeziFHIR


extension FHIRStore {
    /// Loads a mock resource into the `FHIRStore` for testing purposes.
    public func loadTestingResources() {
        let mockObservation = Observation(
            code: CodeableConcept(coding: [Coding(code: "1234".asFHIRStringPrimitive())]),
            id: FHIRPrimitive<FHIRString>("1234"),
            issued: FHIRPrimitive<Instant>(try? Instant(date: .now)),
            status: FHIRPrimitive(ObservationStatus.final)
        )
        
        let mockFHIRResource = FHIRResource(
            versionedResource: .r4(mockObservation),
            displayName: "Mock Resource"
        )
        
        removeAllResources()
        insert(resource: mockFHIRResource)
    }
}
