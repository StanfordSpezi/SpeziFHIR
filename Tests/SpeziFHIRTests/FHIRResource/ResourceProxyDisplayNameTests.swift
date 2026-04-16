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
        var mockCondition = try ModelsR4Mocks.createCondition()
        // Test with text value
        mockCondition.code = CodeableConcept(text: "Hypertension")
        #expect(ResourceProxy(with: mockCondition).displayName == "Hypertension")
        // Test with no code
        mockCondition.code = nil
        #expect(ResourceProxy(with: mockCondition).displayName == "Condition")
    }
    
    
    @Test
    func testDiagnosticReportDisplayName() throws {
        var mockReport = try ModelsR4Mocks.createDiagnosticReport()
        // Test with display coding
        mockReport.code.coding = [Coding(display: "Blood Test")]
        #expect(ResourceProxy(with: mockReport).displayName == "Blood Test")
        // Test with no codings
        mockReport.code.coding?.removeAll()
        #expect(ResourceProxy(with: mockReport).displayName == "DiagnosticReport")
    }
    
    
    @Test
    func testEncounterDisplayName() throws {
        var mockEncounter = try ModelsR4Mocks.createEncounter()
        // Test with reason code
        mockEncounter.reasonCode = [CodeableConcept(coding: [Coding(display: "Follow-up")])]
        #expect(ResourceProxy(with: mockEncounter).displayName == "Follow-up")
        // Test with encounter type
        mockEncounter.reasonCode = nil
        mockEncounter.type = [CodeableConcept(coding: [Coding(display: "Office Visit")])]
        #expect(ResourceProxy(with: mockEncounter).displayName == "Office Visit")
        // Test with no type or reason
        mockEncounter.type = nil
        #expect(ResourceProxy(with: mockEncounter).displayName == "Encounter")
    }
    
    
    @Test
    func testImmunizationDisplayName() throws {
        var mockImmunization = try ModelsR4Mocks.createImmunization()
        // Test with vaccine text
        mockImmunization.vaccineCode.text = "Flu Shot"
        #expect(ResourceProxy(with: mockImmunization).displayName == "Flu Shot")
        // Test with no vaccine text
        mockImmunization.vaccineCode.text = nil
        #expect(ResourceProxy(with: mockImmunization).displayName == "Immunization")
    }
    
    
    @Test
    func testMedicationRequestDisplayName() throws {
        var mockMedRequest = try ModelsR4Mocks.createMedicationRequest()
        // Test with codeable concept text
        if case .codeableConcept(var medicationCode) = mockMedRequest.medication {
            medicationCode.text = "Aspirin"
            mockMedRequest.medication = .codeableConcept(medicationCode)
        }
        #expect(ResourceProxy(with: mockMedRequest).displayName == "Aspirin")
        // Test with no text in codeable concept
        if case .codeableConcept(var medicationCode) = mockMedRequest.medication {
            medicationCode.text = nil
            mockMedRequest.medication = .codeableConcept(medicationCode)
        }
        #expect(ResourceProxy(with: mockMedRequest).displayName == "MedicationRequest")
        // Test with reference instead of codeable concept
        mockMedRequest.medication = .reference(Reference())
        #expect(ResourceProxy(with: mockMedRequest).displayName == "MedicationRequest")
    }
    
    
    @Test
    func testObservationDisplayName() throws {
        var mockObservation = try ModelsR4Mocks.createObservation()
        // Test with code text
        mockObservation.code.text = "Blood Pressure"
        #expect(ResourceProxy(with: mockObservation).displayName == "Blood Pressure")
        // Test with no code text
        mockObservation.code.text = nil
        #expect(ResourceProxy(with: mockObservation).displayName == "Observation")
    }
    
    
    @Test
    func testProcedureDisplayName() throws {
        var mockProcedure = try ModelsR4Mocks.createProcedure()
        // Test with code text
        mockProcedure.code = CodeableConcept(text: "Hip Surgery")
        #expect(ResourceProxy(with: mockProcedure).displayName == "Hip Surgery")
        // Test with no code
        mockProcedure.code = nil
        #expect(ResourceProxy(with: mockProcedure).displayName == "Procedure")
    }
    
    
    @Test
    func testPatientDisplayName() throws {
        var mockPatient = try ModelsR4Mocks.createPatient()
        // Test with name components
        mockPatient.name = [HumanName(family: "Doe", given: ["John"])]
        #expect(ResourceProxy(with: mockPatient).displayName == "JohnDoe")
        // Test with no name
        mockPatient.name = nil
        #expect(ResourceProxy(with: mockPatient).displayName == "Patient")
    }
}
