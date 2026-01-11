//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
@testable @_spi(Testing) import SpeziFHIR
import Testing


@Suite
@MainActor
struct FHIRStoreTests {
    private let store = FHIRStore()
    

    @Test
    func testInitialState() {
        #expect(store.allergyIntolerances.isEmpty)
        #expect(store.conditions.isEmpty)
        #expect(store.diagnostics.isEmpty)
        #expect(store.encounters.isEmpty)
        #expect(store.immunizations.isEmpty)
        #expect(store.medications.isEmpty)
        #expect(store.observations.isEmpty)
        #expect(store.procedures.isEmpty)
        #expect(store.otherResources.isEmpty)
    }

    @Test
    func testInsertSingleResource() throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")
        store.insert(resource)

        #expect(store.observations.count == 1)
        #expect(store.observations.first?.displayName == "Test Observation")
        #expect(store.conditions.isEmpty)
    }

    @Test
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

        store.insert(contentsOf: resources)
        
        #expect(store.observations.count == 2)
        #expect(store.procedures.count == 1)
        #expect(store.medications.count == 1)
        #expect(store.otherResources.count == 1)
    }

    @Test
    func testRemoveResource() {
        let medication = ModelsR4Mocks.createMedication()
        let resource = FHIRResource(resource: medication, displayName: "Medication")
            
        store.insert(resource)
        #expect(store.medications.count == 1)
        
        store.removeResource(withId: resource.id.fhirResourceId)
        #expect(store.medications.isEmpty)
    }

    @Test
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
        
        store.insert(contentsOf: resources)
        store.removeAllResources()

        #expect(store.observations.isEmpty)
        #expect(store.conditions.isEmpty)
        #expect(store.medications.isEmpty)
    }

    @Test
    func testLoadEmptyBundle() {
        let bundle = ModelsR4.Bundle(type: FHIRPrimitive<BundleType>(.transaction))
        store.load(bundle: bundle)
        #expect(store.allergyIntolerances.isEmpty)
        #expect(store.conditions.isEmpty)
        #expect(store.observations.isEmpty)
        #expect(store.diagnostics.isEmpty)
        #expect(store.encounters.isEmpty)
        #expect(store.immunizations.isEmpty)
        #expect(store.observations.isEmpty)
        #expect(store.procedures.isEmpty)
        #expect(store.otherResources.isEmpty)
    }

    @Test
    func testLoadBundleWithMultipleResources() throws {
        store.load(bundle: try ModelsR4Mocks.createBundle())
        #expect(store.conditions.count == 1)
        #expect(store.observations.count == 1)
        #expect(store.conditions.first?.fhirId == "condition-id")
        #expect(store.observations.first?.fhirId == "observation-id")
    }

    @Test
    func testLoadBundleWithInvalidResources() throws {
        let bundle = try ModelsR4Mocks.createBundle()
        let condition = try ModelsR4Mocks.createCondition()
        let emptyEntry = BundleEntry()
        bundle.entry = [
            emptyEntry,
            BundleEntry(resource: .condition(condition))
        ]
        
        store.load(bundle: bundle)
        #expect(store.conditions.count == 1)
        #expect(store.conditions.first?.id.fhirResourceId == "condition-id")
        #expect(store.otherResources.isEmpty)
    }

    @Test
    func testLoadBundleWithDuplicateResources() throws {
        #expect(store.isEmpty)
        
        let bundle = try ModelsR4Mocks.createBundle()
        let condition1 = try ModelsR4Mocks.createCondition()
        let condition2 = try ModelsR4Mocks.createCondition()
        bundle.entry = [
            BundleEntry(resource: .condition(condition1)),
            BundleEntry(resource: .condition(condition2))
        ]
        
        store.load(bundle: bundle)
        #expect(store.conditions.count == 1)
        #expect(try #require(store.conditions.first).id.fhirResourceId == "condition-id")
    }
}
