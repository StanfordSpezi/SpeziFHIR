//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
@testable import SpeziFHIR
import Testing

extension FHIRResourceTests {
    @Test
    func testMatchesDisplayName() throws {
        let observation = try ModelsR4Mocks.createObservation()
        
        let resource = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test Resource"
        )
        
        #expect(resource.matchesDisplayName(with: "test"))
        #expect(resource.matchesDisplayName(with: "resource"))
        #expect(resource.matchesDisplayName(with: "  test  "))
        #expect(resource.matchesDisplayName(with: "TEST"))
        #expect(!resource.matchesDisplayName(with: "xyz"))
        #expect(!resource.matchesDisplayName(with: ""))
    }
    
    @Test
    func testFilterByDisplayName() throws {
        let observation = try ModelsR4Mocks.createObservation()
        let patient = try ModelsR4Mocks.createPatient()
        let medicationRequest = try ModelsR4Mocks.createMedicationRequest()
        
        let resource1 = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test Resource1"
        )
        let resource2 = FHIRResource(
            versionedResource: .r4(patient),
            displayName: "Test Resource2"
        )
        let resource3 = FHIRResource(
            versionedResource: .r4(medicationRequest),
            displayName: "Test Resource3"
        )
        
        let resources: Set = [resource1, resource2, resource3]
        #expect(resources.filterByDisplayName(with: "test").count == 3)
        #expect(resources.filterByDisplayName(with: "resource1").count == 1)
        #expect(resources.filterByDisplayName(with: "xyz").isEmpty)
        #expect(resources.filterByDisplayName(with: "").count == 3)
    }
}
