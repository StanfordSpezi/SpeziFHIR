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
    func testConditionDisplayName() throws {
        let mockCondition = try ModelsR4Mocks.createCondition()
        
        // Test with text value
        mockCondition.code = CodeableConcept(text: "Hypertension")
        let proxy = ResourceProxy(with: mockCondition)
        #expect(proxy.displayName == "Hypertension")
        
        // Test with no code
        mockCondition.code = nil
        #expect(proxy.displayName == "Condition")
    }
    
    @Test
    func testDiagnosticReportDisplayName() throws {
        let mockReport = try ModelsR4Mocks.createDiagnosticReport()
        
        // Test with display coding
        mockReport.code.coding = [Coding(display: "Blood Test")]
        let proxy = ResourceProxy(with: mockReport)
        #expect(proxy.displayName == "Blood Test")
        
        // Test with no codings
        mockReport.code.coding?.removeAll()
        #expect(proxy.displayName == "DiagnosticReport")
    }
    
    @Test
    func testEncounterDisplayName() throws {
        let mockEncounter = try ModelsR4Mocks.createEncounter()
        
        // Test with reason code
        mockEncounter.reasonCode = [CodeableConcept(coding: [Coding(display: "Follow-up")])]
        let proxy = ResourceProxy(with: mockEncounter)
        #expect(proxy.displayName == "Follow-up")
        
        // Test with encounter type
        mockEncounter.reasonCode = nil
        mockEncounter.type = [CodeableConcept(coding: [Coding(display: "Office Visit")])]
        #expect(proxy.displayName == "Office Visit")
        
        // Test with no type or reason
        mockEncounter.type = nil
        #expect(proxy.displayName == "Encounter")
    }
    
    @Test
    func testImmunizationDisplayName() throws {
        let mockImmunization = try ModelsR4Mocks.createImmunization()
        
        // Test with vaccine text
        mockImmunization.vaccineCode.text = "Flu Shot"
        let proxy = ResourceProxy(with: mockImmunization)
        #expect(proxy.displayName == "Flu Shot")
        
        // Test with no vaccine text
        mockImmunization.vaccineCode.text = nil
        #expect(proxy.displayName == "Immunization")
    }
    
    @Test
    func testMedicationRequestDisplayName() throws {
        let mockMedRequest = try ModelsR4Mocks.createMedicationRequest()
        
        // Test with codeable concept text
        if case let .codeableConcept(medicationCode) = mockMedRequest.medication {
            medicationCode.text = "Aspirin"
        }
        let proxy = ResourceProxy(with: mockMedRequest)
        #expect(proxy.displayName == "Aspirin")
        
        // Test with no text in codeable concept
        if case let .codeableConcept(medicationCode) = mockMedRequest.medication {
            medicationCode.text = nil
        }
        #expect(proxy.displayName == "MedicationRequest")
        
        // Test with reference instead of codeable concept
        mockMedRequest.medication = .reference(Reference())
        #expect(proxy.displayName == "MedicationRequest")
    }
    
    @Test
    func testObservationDisplayName() throws {
        let mockObservation = try ModelsR4Mocks.createObservation()
        
        // Test with code text
        mockObservation.code.text = "Blood Pressure"
        let proxy = ResourceProxy(with: mockObservation)
        #expect(proxy.displayName == "Blood Pressure")
        
        // Test with no code text
        mockObservation.code.text = nil
        #expect(proxy.displayName == "Observation")
    }
    
    @Test
    func testProcedureDisplayName() throws {
        let mockProcedure = try ModelsR4Mocks.createProcedure()
        
        // Test with code text
        mockProcedure.code = CodeableConcept(text: "Hip Surgery")
        let proxy = ResourceProxy(with: mockProcedure)
        #expect(proxy.displayName == "Hip Surgery")
        
        // Test with no code
        mockProcedure.code = nil
        #expect(proxy.displayName == "Procedure")
    }
    
    @Test
    func testPatientDisplayName() throws {
        let mockPatient = try ModelsR4Mocks.createPatient()
        
        // Test with name components
        mockPatient.name = [HumanName(family: "Doe", given: ["John"])]
        let proxy = ResourceProxy(with: mockPatient)
        #expect(proxy.displayName == "JohnDoe")
        
        // Test with no name
        mockPatient.name = nil
        #expect(proxy.displayName == "Patient")
    }
}
