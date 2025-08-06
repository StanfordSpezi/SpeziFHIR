//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import Observation
@testable import SpeziFHIR
import Testing


@Suite
@MainActor
struct FHIRStoreObservationChangesTests {
    private var store = FHIRStore()
    

    @Test
    func testChangesOnInsert() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")

        await confirmation { observationsExpectation in
            withObservationTracking {
                #expect(store.procedures.isEmpty)
                #expect(store.observations.isEmpty)
            } onChange: {
                observationsExpectation()
            }
            
            store.insert(resource: resource)
            
            #expect(store.procedures.isEmpty)
            #expect(store.observations.count == 1)
        }
    }

    @Test
    func testChangesOnBulkInsert() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let observationResource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        let medication = ModelsR4Mocks.createMedication()
        let medicationResource = FHIRResource(resource: medication, displayName: "Test Medication")

        await confirmation("Observations and medications should change", expectedCount: 3) { changeExpectation in
            withObservationTracking {
                #expect(store.procedures.isEmpty)
                #expect(store.observations.isEmpty)
                #expect(store.medications.isEmpty)
            } onChange: {
                // Should be triggered, but only once.
                changeExpectation()
            }
            withObservationTracking {
                #expect(store.procedures.isEmpty)
            } onChange: {
                changeExpectation()
            }
            withObservationTracking {
                // Should be triggered
                #expect(store.observations.isEmpty)
            } onChange: {
                changeExpectation()
            }
            withObservationTracking {
                #expect(store.medications.isEmpty)
            } onChange: {
                // Should be triggered
                changeExpectation()
            }
            
            store.insert(resources: [observationResource, medicationResource])
            
            #expect(store.procedures.isEmpty)
            #expect(store.observations.count == 1)
            #expect(store.medications.count == 1)
        }
    }

    @Test
    func testChangesOnRemove() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        store.insert(resource: resource)
        
        await confirmation { observationsExpectation in
            withObservationTracking {
                #expect(store.observations.count == 1)
                #expect(store.procedures.isEmpty)
            } onChange: {
                observationsExpectation()
            }
            
            store.remove(resource: resource.id)
            
            #expect(store.procedures.isEmpty)
            #expect(store.observations.isEmpty)
        }
    }
    
    // swiftlint:disable function_body_length
    @Test
    func testChangesOnRemoveAll() async throws {
        let allergyIntolerance = ModelsR4Mocks.createAllergyIntolerance()
        let allergyIntoleranceResource = FHIRResource(resource: allergyIntolerance, displayName: "Test Allergy Intolerance")
        
        let condition = try ModelsR4Mocks.createCondition()
        let conditionResource = FHIRResource(resource: condition, displayName: "Test Condition")
        
        let diagnostic = try ModelsR4Mocks.createDiagnosticReport()
        let diagnosticResource = FHIRResource(resource: diagnostic, displayName: "Test Diagnostic")
        
        let encounter = try ModelsR4Mocks.createEncounter()
        let encounterResource = FHIRResource(resource: encounter, displayName: "Test Encounter")
        
        let immunization = try ModelsR4Mocks.createImmunization()
        let immunizationResource = FHIRResource(resource: immunization, displayName: "Test Immunization")
        
        let observation = try ModelsR4Mocks.createObservation()
        let observationResource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        let medication = ModelsR4Mocks.createMedication()
        let medicationResource = FHIRResource(resource: medication, displayName: "Test Medication")

        let procedure = try ModelsR4Mocks.createProcedure()
        let procedureResource = FHIRResource(resource: procedure, displayName: "Test Procedure")
        
        let other = try ModelsR4Mocks.createProvenance()
        let otherResource = FHIRResource(resource: other, displayName: "Test Other")
        
        store.insert(resources: [
            allergyIntoleranceResource,
            conditionResource,
            diagnosticResource,
            encounterResource,
            immunizationResource,
            observationResource,
            medicationResource,
            procedureResource,
            otherResource
        ])

        await confirmation("All resource collections should change", expectedCount: 10) { changeExpectation in
            withObservationTracking {
                #expect(store.allergyIntolerances.count == 1)
                #expect(store.conditions.count == 1)
                #expect(store.diagnostics.count == 1)
                #expect(store.encounters.count == 1)
                #expect(store.immunizations.count == 1)
                #expect(store.procedures.count == 1)
                #expect(store.observations.count == 1)
                #expect(store.medications.count == 1)
                #expect(store.otherResources.count == 1)
            } onChange: {
                // Should be triggered, but only once.
                changeExpectation()
            }
            withObservationTracking { #expect(store.allergyIntolerances.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.conditions.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.diagnostics.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.encounters.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.immunizations.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.procedures.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.observations.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.medications.count == 1) } onChange: { changeExpectation() }
            withObservationTracking { #expect(store.otherResources.count == 1) } onChange: { changeExpectation() }
            
            store.removeAllResources()
            
            // Verify all resources were removed
            #expect(store.allergyIntolerances.isEmpty)
            #expect(store.conditions.isEmpty)
            #expect(store.diagnostics.isEmpty)
            #expect(store.encounters.isEmpty)
            #expect(store.immunizations.isEmpty)
            #expect(store.procedures.isEmpty)
            #expect(store.observations.isEmpty)
            #expect(store.medications.isEmpty)
            #expect(store.otherResources.isEmpty)
        }
    }
}
