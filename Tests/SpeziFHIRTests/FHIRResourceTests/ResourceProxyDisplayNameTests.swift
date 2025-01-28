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
    func testConditionDisplayName() throws {
        let mockCondition = try ModelsR4Mocks.createCondition(date: testDate)
        
        // Test with text value
        mockCondition.code = CodeableConcept(text: "Hypertension")
        let proxy = ResourceProxy(with: mockCondition)
        XCTAssertEqual(proxy.displayName, "Hypertension")
        
        // Test with no code
        mockCondition.code = nil
        XCTAssertEqual(proxy.displayName, "Condition")
    }
    
    func testDiagnosticReportDisplayName() throws {
        let mockReport = try ModelsR4Mocks.createDiagnosticReport(date: testDate)
        
        // Test with display coding
        mockReport.code.coding = [Coding(display: "Blood Test")]
        let proxy = ResourceProxy(with: mockReport)
        XCTAssertEqual(proxy.displayName, "Blood Test")
        
        // Test with no codings
        mockReport.code.coding?.removeAll()
        XCTAssertEqual(proxy.displayName, "DiagnosticReport")
    }
    
    func testEncounterDisplayName() throws {
        let mockEncounter = try ModelsR4Mocks.createEncounter(date: testDate)
        
        // Test with reason code
        mockEncounter.reasonCode = [CodeableConcept(coding: [Coding(display: "Follow-up")])]
        let proxy = ResourceProxy(with: mockEncounter)
        XCTAssertEqual(proxy.displayName, "Follow-up")
        
        // Test with encounter type
        mockEncounter.reasonCode = nil
        mockEncounter.type = [CodeableConcept(coding: [Coding(display: "Office Visit")])]
        XCTAssertEqual(proxy.displayName, "Office Visit")
        
        // Test with no type or reason
        mockEncounter.type = nil
        XCTAssertEqual(proxy.displayName, "Encounter")
    }
    
    func testImmunizationDisplayName() throws {
        let mockImmunization = try ModelsR4Mocks.createImmunization(date: testDate)
        
        // Test with vaccine text
        mockImmunization.vaccineCode.text = "Flu Shot"
        let proxy = ResourceProxy(with: mockImmunization)
        XCTAssertEqual(proxy.displayName, "Flu Shot")
        
        // Test with no vaccine text
        mockImmunization.vaccineCode.text = nil
        XCTAssertEqual(proxy.displayName, "Immunization")
    }
    
    func testMedicationRequestDisplayName() throws {
        let mockMedRequest = try ModelsR4Mocks.createMedicationRequest(date: testDate)
        
        // Test with codeable concept text
        if case let .codeableConcept(medicationCode) = mockMedRequest.medication {
            medicationCode.text = "Aspirin"
        }
        let proxy = ResourceProxy(with: mockMedRequest)
        XCTAssertEqual(proxy.displayName, "Aspirin")
        
        // Test with no text in codeable concept
        if case let .codeableConcept(medicationCode) = mockMedRequest.medication {
            medicationCode.text = nil
        }
        XCTAssertEqual(proxy.displayName, "MedicationRequest")
        
        // Test with reference instead of codeable concept
        mockMedRequest.medication = .reference(Reference())
        XCTAssertEqual(proxy.displayName, "MedicationRequest")
    }
    
    func testObservationDisplayName() throws {
        let mockObservation = try ModelsR4Mocks.createObservation(date: testDate)
        
        // Test with code text
        mockObservation.code.text = "Blood Pressure"
        let proxy = ResourceProxy(with: mockObservation)
        XCTAssertEqual(proxy.displayName, "Blood Pressure")
        
        // Test with no code text
        mockObservation.code.text = nil
        XCTAssertEqual(proxy.displayName, "Observation")
    }
    
    func testProcedureDisplayName() throws {
        let mockProcedure = try ModelsR4Mocks.createProcedure(date: testDate)
        
        // Test with code text
        mockProcedure.code = CodeableConcept(text: "Hip Surgery")
        let proxy = ResourceProxy(with: mockProcedure)
        XCTAssertEqual(proxy.displayName, "Hip Surgery")
        
        // Test with no code
        mockProcedure.code = nil
        XCTAssertEqual(proxy.displayName, "Procedure")
    }
    
    func testPatientDisplayName() throws {
        let mockPatient = try ModelsR4Mocks.createPatient(date: testDate)
        
        // Test with name components
        mockPatient.name = [HumanName(family: "Doe", given: ["John"])]
        let proxy = ResourceProxy(with: mockPatient)
        XCTAssertEqual(proxy.displayName, "JohnDoe")
        
        // Test with no name
        mockPatient.name = nil
        XCTAssertEqual(proxy.displayName, "Patient")
    }
}
