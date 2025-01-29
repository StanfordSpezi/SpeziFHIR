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


final class FHIRStoreTests: XCTestCase {
    var store: FHIRStore!
    
    override func setUp() {
        super.setUp()
        store = FHIRStore()
    }
    
    override func tearDown() {
        store = nil
        super.tearDown()
    }
    
    @MainActor
    func testInitialState() async {
        await MainActor.run {
            XCTAssertTrue(store.allergyIntolerances.isEmpty)
            XCTAssertTrue(store.conditions.isEmpty)
            XCTAssertTrue(store.diagnostics.isEmpty)
            XCTAssertTrue(store.encounters.isEmpty)
            XCTAssertTrue(store.immunizations.isEmpty)
            XCTAssertTrue(store.medications.isEmpty)
            XCTAssertTrue(store.observations.isEmpty)
            XCTAssertTrue(store.procedures.isEmpty)
            XCTAssertTrue(store.otherResources.isEmpty)
        }
    }
    
    @MainActor
    func testInsertSingleResource() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        await MainActor.run {
            store.insert(resource: resource)
            
            XCTAssertEqual(store.observations.count, 1)
            XCTAssertEqual(store.observations.first?.displayName, "Test Observation")
            XCTAssertTrue(store.conditions.isEmpty)
        }
    }
    
    @MainActor
    func testInsertMultipleResources() async throws {
        let observation1 = try ModelsR4Mocks.createObservation()
        let observation2 = try ModelsR4Mocks.createObservation()
        let procedure = try ModelsR4Mocks.createProcedure()
        let medication = ModelsR4Mocks.createMedication()
        let claim = try ModelsR4Mocks.createClaim()

        let resources = [
            FHIRResource(resource: observation1, displayName: "Observation 1"),
            FHIRResource(resource: observation2, displayName: "Observation 2"),
            FHIRResource(resource: procedure, displayName: "Procedure"),
            FHIRResource(resource: medication, displayName: "Medication"),
            FHIRResource(resource: claim, displayName: "Claim")
        ]

        await MainActor.run {
            store.insert(resources: resources)
            
            XCTAssertEqual(store.observations.count, 2)
            XCTAssertEqual(store.procedures.count, 1)
            XCTAssertEqual(store.medications.count, 1)
            XCTAssertEqual(store.otherResources.count, 1)
        }
    }
    
    @MainActor
    func testRemoveResource() async {
        let medication = ModelsR4Mocks.createMedication()
        let resource = FHIRResource(resource: medication, displayName: "Medication")
            
        await MainActor.run {
            store.insert(resource: resource)
            XCTAssertEqual(store.medications.count, 1)
            
            store.remove(resource: resource.id)
            XCTAssertTrue(store.medications.isEmpty)
        }
    }
    
    @MainActor
    func testRemoveAllResources() async throws {
        let observation1 = try ModelsR4Mocks.createObservation()
        let observation2 = try ModelsR4Mocks.createObservation()
        let procedure = try ModelsR4Mocks.createProcedure()
        let medication = ModelsR4Mocks.createMedication()

        let resources = [
            FHIRResource(resource: observation1, displayName: "Observation 1"),
            FHIRResource(resource: observation2, displayName: "Observation 2"),
            FHIRResource(resource: procedure, displayName: "Procedure"),
            FHIRResource(resource: medication, displayName: "Medication")
        ]
        
        await MainActor.run {
            store.insert(resources: resources)
            store.removeAllResources()

            XCTAssertTrue(store.observations.isEmpty)
            XCTAssertTrue(store.conditions.isEmpty)
            XCTAssertTrue(store.medications.isEmpty)
        }
    }
}
