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
import Testing


extension FHIRResourceTests {
    @Test
    func testModelsR4Categories() throws {
        // Define test cases as tuples of (resource creator function, expected category)
        let testCases: [(resource: () throws -> ModelsR4.Resource, category: FHIRResource.FHIRResourceCategory)] = [
            // Observation cases
            ({ try ModelsR4Mocks.createObservation() }, .observation),
            ({ ModelsR4Mocks.createObservationDefinition() }, .observation),
            
            // Single resource cases
            ({ try ModelsR4Mocks.createEncounter() }, .encounter),
            ({ try ModelsR4Mocks.createCondition() }, .condition),
            ({ try ModelsR4Mocks.createDiagnosticReport() }, .diagnostic),
            ({ try ModelsR4Mocks.createProcedure() }, .procedure),
            ({ ModelsR4Mocks.createAllergyIntolerance() }, .allergyIntolerance),
            
            // Immunization cases
            ({ try ModelsR4Mocks.createImmunization() }, .immunization),
            ({ ModelsR4Mocks.createImmunizationEvaluation() }, .immunization),
            ({ try ModelsR4Mocks.createImmunizationRecommendation(date: Self.testDate) }, .immunization),
            
            // Medication cases
            ({ ModelsR4Mocks.createMedication() }, .medication),
            ({ try ModelsR4Mocks.createMedicationRequest() }, .medication),
            ({ try ModelsR4Mocks.createMedicationAdministration() }, .medication),
            ({ ModelsR4Mocks.createMedicationDispense() }, .medication),
            ({ ModelsR4Mocks.createMedicationKnowledge() }, .medication),
            ({ ModelsR4Mocks.createMedicationStatement() }, .medication)
        ]
        
        try testCases.forEach { creator, expectedCategory in
            let resource = try creator()
            let fhirResource = FHIRResource(versionedResource: .r4(resource), displayName: "")
            #expect(fhirResource.category == expectedCategory, "Failed for resource type: \(type(of: resource))")
        }
    }
    
    @Test
    func testModelsDSTU2Categories() throws {
        let testCases: [(resource: () throws -> ModelsDSTU2.Resource, category: FHIRResource.FHIRResourceCategory)] = [
            // Single resource cases
            ({ ModelsDSTU2Mocks.createAllergyIntolerance() }, .allergyIntolerance),
            ({ ModelsDSTU2Mocks.createEncounter() }, .encounter),
            ({ try ModelsDSTU2Mocks.createObservation() }, .observation),
            ({ try ModelsDSTU2Mocks.createCondition() }, .condition),
            
            // Diagnostic cases
            ({ try ModelsDSTU2Mocks.createDiagnosticReport() }, .diagnostic),
            ({ ModelsDSTU2Mocks.createDiagnosticOrder() }, .diagnostic),
            
            // Procedure cases
            ({ try ModelsDSTU2Mocks.createProcedure() }, .procedure),
            ({ ModelsDSTU2Mocks.createProcedureRequest() }, .procedure),
            
            // Immunization cases
            ({ ModelsDSTU2Mocks.createImmunization() }, .immunization),
            ({ ModelsDSTU2Mocks.createImmunizationRecommendation() }, .immunization),
            
            // Medication cases
            ({ ModelsDSTU2Mocks.createMedication() }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationOrder() }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationAdministration() }, .medication),
            ({ ModelsDSTU2Mocks.createMedicationDispense() }, .medication),
            ({ try ModelsDSTU2Mocks.createMedicationStatement() }, .medication)
        ]
        
        try testCases.forEach { creator, expectedCategory in
            let resource = try creator()
            let fhirResource = FHIRResource(versionedResource: .dstu2(resource), displayName: "")
            #expect(fhirResource.category == expectedCategory, "Failed for resource type: \(type(of: resource))")
        }
    }
    
    @Test
    @MainActor
    func testCategoryKeyPaths() {
        #expect(FHIRResource.FHIRResourceCategory.observation.storeKeyPath == \FHIRStore.observations)
        #expect(FHIRResource.FHIRResourceCategory.encounter.storeKeyPath == \FHIRStore.encounters)
        #expect(FHIRResource.FHIRResourceCategory.condition.storeKeyPath == \FHIRStore.conditions)
        #expect(FHIRResource.FHIRResourceCategory.diagnostic.storeKeyPath == \FHIRStore.diagnostics)
        #expect(FHIRResource.FHIRResourceCategory.procedure.storeKeyPath == \FHIRStore.procedures)
        #expect(FHIRResource.FHIRResourceCategory.immunization.storeKeyPath == \FHIRStore.immunizations)
        #expect(FHIRResource.FHIRResourceCategory.allergyIntolerance.storeKeyPath == \FHIRStore.allergyIntolerances)
        #expect(FHIRResource.FHIRResourceCategory.medication.storeKeyPath == \FHIRStore.medications)
        #expect(FHIRResource.FHIRResourceCategory.other.storeKeyPath == \FHIRStore.otherResources)
    }
}
