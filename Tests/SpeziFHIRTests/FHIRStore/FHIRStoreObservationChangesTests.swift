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


final class FHIRStoreObservationChangesTests: XCTestCase {
    private var store: FHIRStore! // swiftlint:disable:this implicitly_unwrapped_optional

    
    override func setUp() {
        super.setUp()
        store = FHIRStore()
    }
    
    override func tearDown() {
        store = nil
        super.tearDown()
    }
    
    @MainActor
    func testChangesOnInsert() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")

        let observationsExpectation = expectation(description: "Observations should change")
        let proceduresExpectation = expectation(description: "Procedures should NOT change")
        proceduresExpectation.isInverted = true

        withObservationTracking {
            _ = store.procedures.count
        } onChange: {
            proceduresExpectation.fulfill()
        }

        withObservationTracking {
            _ = store.observations.count
        } onChange: {
            observationsExpectation.fulfill()
        }

        store.insert(resource: resource)
        
        await fulfillment(of: [observationsExpectation, proceduresExpectation], timeout: 1.0)
        
        XCTAssertEqual(store.procedures.count, 0)
        XCTAssertEqual(store.observations.count, 1)
    }
    
    @MainActor
    func testChangesOnBulkInsert() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let observationResource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        let medication = ModelsR4Mocks.createMedication()
        let medicationResource = FHIRResource(resource: medication, displayName: "Test Medication")

        let observationsExpectation = expectation(description: "Observations should change")
        let medicationsExpectation = expectation(description: "Medications should change")
        let proceduresExpectation = expectation(description: "Procedures should NOT change")
        proceduresExpectation.isInverted = true

        withObservationTracking {
            _ = store.procedures.count
        } onChange: {
            proceduresExpectation.fulfill()
        }

        withObservationTracking {
            _ = store.observations.count
        } onChange: {
            observationsExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.medications.count
        } onChange: {
            medicationsExpectation.fulfill()
        }

        store.insert(resources: [observationResource, medicationResource])
        
        await fulfillment(of: [observationsExpectation, medicationsExpectation, proceduresExpectation], timeout: 1.0)
        
        XCTAssertEqual(store.procedures.count, 0)
        XCTAssertEqual(store.observations.count, 1)
        XCTAssertEqual(store.medications.count, 1)
    }
    
    @MainActor
    func testChangesOnRemove() async throws {
        let observation = try ModelsR4Mocks.createObservation()
        let resource = FHIRResource(resource: observation, displayName: "Test Observation")
        
        store.insert(resource: resource)

        let observationsExpectation = expectation(description: "Observations should change")
        let proceduresExpectation = expectation(description: "Procedures should NOT change")
        proceduresExpectation.isInverted = true

        withObservationTracking {
            _ = store.procedures.count
        } onChange: {
            proceduresExpectation.fulfill()
        }

        withObservationTracking {
            _ = store.observations.count
        } onChange: {
            observationsExpectation.fulfill()
        }

        store.remove(resource: resource.id)
        
        await fulfillment(of: [observationsExpectation, proceduresExpectation], timeout: 1.0)
        
        XCTAssertEqual(store.procedures.count, 0)
        XCTAssertEqual(store.observations.count, 0)
    }
    
    // swiftlint:disable function_body_length
    @MainActor
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
        
        let allergyIntolerancesExpectation = expectation(description: "Allergy Intolerances should change")
        let conditionsExpectation = expectation(description: "Conditions should change")
        let diagnosticsExpectation = expectation(description: "Diagnostics should change")
        let encountersExpectation = expectation(description: "Encounters should change")
        let immunizationsExpectation = expectation(description: "Immunizations should change")
        let observationsExpectation = expectation(description: "Observations should change")
        let medicationsExpectation = expectation(description: "Medications should change")
        let proceduresExpectation = expectation(description: "Procedures should change")
        let otherResourcesExpectation = expectation(description: "Other Resources should change")

        withObservationTracking {
            _ = store.allergyIntolerances.count
        } onChange: {
            allergyIntolerancesExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.conditions.count
        } onChange: {
            conditionsExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.diagnostics.count
        } onChange: {
            diagnosticsExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.encounters.count
        } onChange: {
            encountersExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.immunizations.count
        } onChange: {
            immunizationsExpectation.fulfill()
        }

        withObservationTracking {
            _ = store.procedures.count
        } onChange: {
            proceduresExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.observations.count
        } onChange: {
            observationsExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.medications.count
        } onChange: {
            medicationsExpectation.fulfill()
        }
        
        withObservationTracking {
            _ = store.otherResources.count
        } onChange: {
            otherResourcesExpectation.fulfill()
        }

        store.removeAllResources()
        
        let expectations = [
            allergyIntolerancesExpectation,
            conditionsExpectation,
            diagnosticsExpectation,
            encountersExpectation,
            immunizationsExpectation,
            proceduresExpectation,
            observationsExpectation,
            medicationsExpectation,
            otherResourcesExpectation
        ]
        
        await fulfillment(of: expectations, timeout: 1.0)
        
        XCTAssertEqual(store.allergyIntolerances.count, 0)
        XCTAssertEqual(store.conditions.count, 0)
        XCTAssertEqual(store.diagnostics.count, 0)
        XCTAssertEqual(store.encounters.count, 0)
        XCTAssertEqual(store.immunizations.count, 0)
        XCTAssertEqual(store.procedures.count, 0)
        XCTAssertEqual(store.observations.count, 0)
        XCTAssertEqual(store.medications.count, 0)
        XCTAssertEqual(store.otherResources .count, 0)
    }
}
