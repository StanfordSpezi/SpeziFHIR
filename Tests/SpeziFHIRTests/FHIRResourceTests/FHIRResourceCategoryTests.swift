//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4
@testable import SpeziFHIR
import XCTest


extension FHIRResourceTests {
    func testModelsR4Categories() throws {
        // Define test cases as tuples of (resource creator function, expected category)
        let testCases: [(resource: () throws -> ModelsR4.Resource, category: FHIRResource.FHIRResourceCategory)] = [
            // Observation cases
            ({ try ModelsR4Mocks.createObservation(date: self.testDate) }, .observation),
            ({ ModelsR4Mocks.createObservationDefinition() }, .observation),
            
            // Single resource cases
            ({ try ModelsR4Mocks.createEncounter(date: self.testDate) }, .encounter),
            ({ try ModelsR4Mocks.createCondition(date: self.testDate) }, .condition),
            ({ try ModelsR4Mocks.createDiagnosticReport(date: self.testDate) }, .diagnostic),
            ({ try ModelsR4Mocks.createProcedure(date: self.testDate) }, .procedure),
            ({ ModelsR4Mocks.createAllergyIntolerance() }, .allergyIntolerance),
            
            // Immunization cases
            ({ try ModelsR4Mocks.createImmunization(date: self.testDate) }, .immunization),
            ({ ModelsR4Mocks.createImmunizationEvaluation() }, .immunization),
            ({ try ModelsR4Mocks.createImmunizationRecommendation(date: self.testDate) }, .immunization),
            
            // Medication cases
            ({ ModelsR4Mocks.createMedication() }, .medication),
            ({ try ModelsR4Mocks.createMedicationRequest(date: self.testDate) }, .medication),
            ({ try ModelsR4Mocks.createMedicationAdministration(date: self.testDate) }, .medication),
            ({ ModelsR4Mocks.createMedicationDispense() }, .medication),
            ({ ModelsR4Mocks.createMedicationKnowledge() }, .medication),
            ({ ModelsR4Mocks.createMedicationStatement() }, .medication)
        ]
        
        try testCases.forEach { creator, expectedCategory in
            let resource = try creator()
            let fhirResource = FHIRResource(versionedResource: .r4(resource), displayName: "")
            XCTAssertEqual(fhirResource.category, expectedCategory, "Failed for resource type: \(type(of: resource))")
        }
    }
    
    func testModelsDSTU2Categories() throws {
        let testCases: [(resource: () throws -> ModelsDSTU2.Resource, category: FHIRResource.FHIRResourceCategory)] = [
            // Single resource cases
            ({ ModelsDSTU2Mocks.createAllergyIntolerance() }, .allergyIntolerance),
            ({ ModelsDSTU2Mocks.createEncounter() }, .encounter),
            ({ try ModelsDSTU2Mocks.createObservation(date: self.testDate) }, .observation),
            ({ try ModelsDSTU2Mocks.createCondition(date: self.testDate) }, .condition),
            
            // Diagnostic cases
            ({ try ModelsDSTU2Mocks.createDiagnosticReport(date: self.testDate) }, .diagnostic),
            ({ try ModelsDSTU2Mocks.createDiagnosticOrder(date: self.testDate) }, .diagnostic),
            
            // Procedure cases
            ({ try ModelsDSTU2Mocks.createProcedure(date: self.testDate) }, .procedure),
            ({ ModelsDSTU2Mocks.createProcedureRequest() }, .procedure),
            
            // Immunization cases
            ({ try ModelsDSTU2Mocks.createImmunization(date: self.testDate) }, .immunization),
            ({ ModelsDSTU2Mocks.createImmunizationRecommendation() }, .immunization),
            
            // Medication cases
            ({ ModelsDSTU2Mocks.createMedication() }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationOrder(date: self.testDate) }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationAdministration(date: self.testDate) }, .medication),
            ({ ModelsDSTU2Mocks.createMedicationDispense() }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationStatement(date: self.testDate) }, .medication)
        ]
        
        try testCases.forEach { creator, expectedCategory in
            let resource = try creator()
            let fhirResource = FHIRResource(versionedResource: .dstu2(resource), displayName: "")
            XCTAssertEqual(fhirResource.category, expectedCategory, "Failed for resource type: \(type(of: resource))")
        }
    }
    
    @MainActor
    func testCategoryKeyPaths() {
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.observation.storeKeyPath, \FHIRStore.observations)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.encounter.storeKeyPath, \FHIRStore.encounters)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.condition.storeKeyPath, \FHIRStore.conditions)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.diagnostic.storeKeyPath, \FHIRStore.diagnostics)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.procedure.storeKeyPath, \FHIRStore.procedures)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.immunization.storeKeyPath, \FHIRStore.immunizations)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.allergyIntolerance.storeKeyPath, \FHIRStore.allergyIntolerances)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.medication.storeKeyPath, \FHIRStore.medications)
        XCTAssertEqual(FHIRResource.FHIRResourceCategory.other.storeKeyPath, \FHIRStore.otherResources)
    }
}
