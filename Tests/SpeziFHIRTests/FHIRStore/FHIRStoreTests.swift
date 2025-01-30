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
    func testInsertSingleResource() throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")
        store.insert(resource: resource)

        XCTAssertEqual(store.observations.count, 1)
        XCTAssertEqual(store.observations.first?.displayName, "Test Observation")
        XCTAssertTrue(store.conditions.isEmpty)
    }

    @MainActor
    func testInsertMultipleResources() throws {
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

        store.insert(resources: resources)
        
        XCTAssertEqual(store.observations.count, 2)
        XCTAssertEqual(store.procedures.count, 1)
        XCTAssertEqual(store.medications.count, 1)
        XCTAssertEqual(store.otherResources.count, 1)
    }
    
    @MainActor
    func testRemoveResource() {
        let medication = ModelsR4Mocks.createMedication()
        let resource = FHIRResource(resource: medication, displayName: "Medication")
            
        store.insert(resource: resource)
        XCTAssertEqual(store.medications.count, 1)
        
        store.remove(resource: resource.id)
        XCTAssertTrue(store.medications.isEmpty)
    }
    
    @MainActor
    func testRemoveAllResources() throws {
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
        
        store.insert(resources: resources)
        store.removeAllResources()

        XCTAssertTrue(store.observations.isEmpty)
        XCTAssertTrue(store.conditions.isEmpty)
        XCTAssertTrue(store.medications.isEmpty)
    }
    
    @MainActor
    func testLoadEmptyBundle() async {
        let bundle = ModelsR4.Bundle(type: FHIRPrimitive<BundleType>(.transaction))

        await store.load(bundle: bundle)

        XCTAssertEqual(store.allergyIntolerances.count, 0)
        XCTAssertEqual(store.conditions.count, 0)
        XCTAssertEqual(store.observations.count, 0)
        XCTAssertEqual(store.diagnostics.count, 0)
        XCTAssertEqual(store.encounters.count, 0)
        XCTAssertEqual(store.immunizations.count, 0)
        XCTAssertEqual(store.observations.count, 0)
        XCTAssertEqual(store.procedures.count, 0)
        XCTAssertEqual(store.otherResources.count, 0)
    }
    
    @MainActor
    func testLoadBundleWithMultipleResources() async throws {
        await store.load(bundle: try ModelsR4Mocks.createBundle())
        
        XCTAssertEqual(store.conditions.count, 1)
        XCTAssertEqual(store.observations.count, 1)
        XCTAssertEqual(store.conditions.first?.id.description, "condition-id")
        XCTAssertEqual(store.observations.first?.id.description, "observation-id")
    }
    
    @MainActor
    func testLoadBundleCancellation() async throws {
        let bundle = try ModelsR4Mocks.createBundle()
            
        var entries: [BundleEntry] = []
        for _ in 0..<100 {
            let condition = try ModelsR4Mocks.createCondition()
            entries.append(BundleEntry(resource: .condition(condition)))
        }
        bundle.entry = entries

        let task = _Concurrency.Task {
            await store.load(bundle: bundle)
        }

        task.cancel()

        await MainActor.run {
            XCTAssertEqual(store.conditions.count, 0)
        }
    }
    
    @MainActor
    func testLoadBundleWithInvalidResources() async throws {
        let bundle = try ModelsR4Mocks.createBundle()
        let condition = try ModelsR4Mocks.createCondition()
        let emptyEntry = BundleEntry()
        
        bundle.entry = [
            emptyEntry,
            BundleEntry(resource: .condition(condition))
        ]
        
        await store.load(bundle: bundle)
        
        XCTAssertEqual(store.conditions.count, 1)
        XCTAssertEqual(store.conditions.first?.id.description, "condition-id")
        XCTAssertEqual(store.otherResources.count, 0)
    }
    
    @MainActor
    func testLoadBundleWithDuplicateResources() async throws {
        let bundle = try ModelsR4Mocks.createBundle()
        let condition1 = try ModelsR4Mocks.createCondition()
        let condition2 = try ModelsR4Mocks.createCondition()
        
        bundle.entry = [
            BundleEntry(resource: .condition(condition1)),
            BundleEntry(resource: .condition(condition2))
        ]
        
        await store.load(bundle: bundle)
        
        XCTAssertEqual(store.conditions.count, 2)
        XCTAssertEqual(store.conditions[0].id.description, "condition-id")
        XCTAssertEqual(store.conditions[1].id.description, "condition-id")
    }
}
