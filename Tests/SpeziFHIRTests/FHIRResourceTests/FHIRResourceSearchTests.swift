//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
@testable import SpeziFHIR
import XCTest

extension FHIRResourceTests {
    func testMatchesDisplayName() throws {
        let observation = try ModelsR4Mocks.createObservation()
        
        let resource = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test Resource"
        )
        
        XCTAssertTrue(resource.matchesDisplayName(with: "test"))
        XCTAssertTrue(resource.matchesDisplayName(with: "resource"))
        XCTAssertTrue(resource.matchesDisplayName(with: "  test  "))
        XCTAssertTrue(resource.matchesDisplayName(with: "TEST"))
        XCTAssertFalse(resource.matchesDisplayName(with: "xyz"))
        XCTAssertFalse(resource.matchesDisplayName(with: ""))
    }
    
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
        
        let resources = [resource1, resource2, resource3]
        
        XCTAssertEqual(resources.filterByDisplayName(with: "test").count, 3)
        XCTAssertEqual(resources.filterByDisplayName(with: "resource1").count, 1)
        XCTAssertEqual(resources.filterByDisplayName(with: "xyz").count, 0)
        XCTAssertEqual(resources.filterByDisplayName(with: "").count, 3)
    }
}
