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


class FHIRResourceTests: XCTestCase {
    private static let utcDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    static let testDate: Date = {
        guard let date = utcDateFormatter.date(from: "2025-01-01") else {
            preconditionFailure("Failed to parse date: Invalid date string format")
        }
        return date
    }()


    func testModelsR4ResourceInitialization() throws {
        let mockObservation = try ModelsR4Mocks.createObservation(issuedDate: Self.testDate)

        let resource = FHIRResource(
            resource: mockObservation,
            displayName: "Test Observation"
        )
        
        XCTAssertEqual(resource.id, "observation-id")
        XCTAssertEqual(resource.displayName, "Test Observation")
        XCTAssertEqual(resource.resourceType, "Observation")
    }
    
    func testModelsDSTU2ResourceInitialization() throws {
        let mockObservation = try ModelsDSTU2Mocks.createObservation(issuedDate: Self.testDate)

        let resource = FHIRResource(
            resource: mockObservation,
            displayName: "Test Observation"
        )
        
        XCTAssertEqual(resource.id, "observation-id")
        XCTAssertEqual(resource.displayName, "Test Observation")
        XCTAssertEqual(resource.resourceType, "Observation")
    }
    
    func testModelsR4ResourceDates() throws {
        let modelsR4Resources: [(ModelsR4.Resource, String)] = try [
            (ModelsR4Mocks.createCarePlan(date: Self.testDate), "CarePlan"),
            (ModelsR4Mocks.createCareTeam(date: Self.testDate), "CareTeam"),
            (ModelsR4Mocks.createClaim(date: Self.testDate), "Claim"),
            (ModelsR4Mocks.createCondition(date: Self.testDate), "Condition"),
            (ModelsR4Mocks.createDevice(date: Self.testDate), "Device"),
            (ModelsR4Mocks.createDiagnosticReport(date: Self.testDate), "DiagnosticReport"),
            (ModelsR4Mocks.createDocumentReference(date: Self.testDate), "DocumentReference"),
            (ModelsR4Mocks.createEncounter(date: Self.testDate), "Encounter"),
            (ModelsR4Mocks.createExplanationOfBenefit(date: Self.testDate), "ExplanationOfBenefit"),
            (ModelsR4Mocks.createImmunization(date: Self.testDate), "Immunization"),
            (ModelsR4Mocks.createMedicationRequest(date: Self.testDate), "MedicationRequest"),
            (ModelsR4Mocks.createMedicationAdministration(date: Self.testDate), "MedicationAdministration"),
            (ModelsR4Mocks.createObservation(issuedDate: Self.testDate), "Observation with issued date"),
            (ModelsR4Mocks.createObservation(effectiveDate: Self.testDate), "Observation with effective date"),
            (ModelsR4Mocks.createProcedure(date: Self.testDate), "Procedure"),
            (ModelsR4Mocks.createPatient(date: Self.testDate), "Patient"),
            (ModelsR4Mocks.createProvenance(date: Self.testDate), "Provenance"),
            (ModelsR4Mocks.createSupplyDelivery(date: Self.testDate), "SupplyDelivery")
        ]
        
        for (resource, name) in modelsR4Resources {
            let fhirResource = FHIRResource(
                versionedResource: .r4(resource),
                displayName: "Test \(name)"
            )
            
            XCTAssertEqual(
                fhirResource.date,
                Self.testDate,
                "Date extraction failed for \(name)"
            )
        }
    }
    
    func testModelsDSTU2ResourceDates() throws {
        let modelsDSTU2Resources: [(ModelsDSTU2.Resource, String)] = try [
            (ModelsDSTU2Mocks.createObservation(issuedDate: Self.testDate), "Observation with issued date"),
            (ModelsDSTU2Mocks.createObservation(effectiveDate: Self.testDate), "Observation with effective date"),
            (ModelsDSTU2Mocks.createMedicationOrder(date: Self.testDate), "MedicationOrder"),
            (ModelsDSTU2Mocks.createMedicationStatement(date: Self.testDate), "MedicationStatement"),
            (ModelsDSTU2Mocks.createCondition(date: Self.testDate), "Condition"),
            (ModelsDSTU2Mocks.createProcedure(date: Self.testDate), "Procedure"),
            (ModelsDSTU2Mocks.createProcedure(date: Self.testDate, usePeriod: false), "Procedure"),
            (ModelsDSTU2Mocks.createProcedure(date: Self.testDate, usePeriod: true), "Procedure with Period")
        ]
        
        for (resource, name) in modelsDSTU2Resources {
            let fhirResource = FHIRResource(
                versionedResource: .dstu2(resource),
                displayName: "Test \(name)"
            )
            
            XCTAssertEqual(
                fhirResource.date,
                Self.testDate,
                "Date extraction failed for DSTU2 \(name)"
            )
        }
    }
    
    func testModelsR4JSON() throws {
        let observation = ModelsR4.Observation(
            code: CodeableConcept(
                coding: [
                    Coding(code: "test-code".asFHIRStringPrimitive())
                ]
            ),
            id: "test-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
        
        let resource = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test"
        )
        
        let jsonString = resource.json(withConfiguration: [])
        
        let jsonData = jsonString.data(using: .utf8) ?? Data()
        let decoder = JSONDecoder()
        let decodedObservation = try decoder.decode(ModelsR4.Observation.self, from: jsonData)
        
        XCTAssertEqual(decodedObservation.id, observation.id)
        XCTAssertEqual(decodedObservation.code, observation.code)
        XCTAssertEqual(decodedObservation.status, observation.status)
    }
    
    func testModelsDSTU2JSON() throws {
        let observation = ModelsDSTU2.Observation(
            code: CodeableConcept(
                coding: [
                    Coding(code: "test-code".asFHIRStringPrimitive())
                ]
            ),
            id: "test-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
        
        let resource = FHIRResource(
            versionedResource: .dstu2(observation),
            displayName: "Test"
        )
        
        let jsonString = resource.json(withConfiguration: [])
        
        let jsonData = jsonString.data(using: .utf8) ?? Data()
        let decoder = JSONDecoder()
        let decodedObservation = try decoder.decode(ModelsDSTU2.Observation.self, from: jsonData)
        
        XCTAssertEqual(decodedObservation.id, observation.id)
        XCTAssertEqual(decodedObservation.code, observation.code)
        XCTAssertEqual(decodedObservation.status, observation.status)
    }
}
