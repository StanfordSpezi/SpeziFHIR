//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4
@testable import SpeziFHIR
import XCTest

final class FHIRResourceTests: XCTestCase {
    
    let testDate = Date(timeIntervalSince1970: 1735123266)
    let calendar = Calendar.current
    
    func testModelsR4ResourceInitialization() throws {
        let mockObservation = try ModelsR4Mocks.createObservation(date: testDate)
        
        let resource = FHIRResource(
            resource: mockObservation,
            displayName: "Test Observation"
        )
        
        XCTAssertEqual(resource.id, "observation-id")
        XCTAssertEqual(resource.displayName, "Test Observation")
        XCTAssertEqual(resource.resourceType, "Observation")
    }
    
    func testModelsDSTU2ResourceInitialization() throws {
        let mockObservation = try ModelsDSTU2Mocks.createObservation(date: testDate)
        
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
            (ModelsR4Mocks.createCarePlan(date: testDate), "CarePlan"),
            (ModelsR4Mocks.createCareTeam(date: testDate), "CareTeam"),
            (ModelsR4Mocks.createClaim(date: testDate), "Claim"),
            (ModelsR4Mocks.createCondition(date: testDate), "Condition"),
            (ModelsR4Mocks.createDevice(date: testDate), "Device"),
            (ModelsR4Mocks.createDiagnosticReport(date: testDate), "DiagnosticReport"),
            (ModelsR4Mocks.createDocumentReference(date: testDate), "DocumentReference"),
            (ModelsR4Mocks.createEncounter(date: testDate), "Encounter"),
            (ModelsR4Mocks.createExplanationOfBenefit(date: testDate), "ExplanationOfBenefit"),
            (ModelsR4Mocks.createImmunization(date: testDate), "Immunization"),
            (ModelsR4Mocks.createMedicationRequest(date: testDate), "MedicationRequest"),
            (ModelsR4Mocks.createMedicationAdministration(date: testDate), "MedicationAdministration"),
            (ModelsR4Mocks.createObservation(date: testDate), "Observation"),
            (ModelsR4Mocks.createProcedure(date: testDate), "Procedure"),
            (ModelsR4Mocks.createPatient(date: testDate), "Patient"),
            (ModelsR4Mocks.createProvenance(date: testDate), "Provenance"),
            (ModelsR4Mocks.createSupplyDelivery(date: testDate), "SupplyDelivery")
        ]
        
        for (resource, name) in modelsR4Resources {
            let fhirResource = FHIRResource(
                versionedResource: .r4(resource),
                displayName: "Test \(name)"
            )
            
            assertEqualDates(fhirResource.date, testDate, name)
        }
    }
    
    func testModelsDSTU2ResourceDates() throws {
        let modelsDSTU2Resources: [(ModelsDSTU2.Resource, String)] = try [
            (ModelsDSTU2Mocks.createObservation(date: testDate), "Observation"),
            (ModelsDSTU2Mocks.createMedicationOrder(date: testDate), "MedicationOrder"),
            (ModelsDSTU2Mocks.createMedicationStatement(date: testDate), "MedicationStatement"),
            (ModelsDSTU2Mocks.createCondition(date: testDate), "Condition"),
            (ModelsDSTU2Mocks.createProcedure(date: testDate), "Procedure"),
            (ModelsDSTU2Mocks.createProcedure(date: testDate, usePeriod: false), "Procedure"),
            (ModelsDSTU2Mocks.createProcedure(date: testDate, usePeriod: true), "Procedure with Period")
        ]
        
        for (resource, name) in modelsDSTU2Resources {
            let fhirResource = FHIRResource(
                versionedResource: .dstu2(resource),
                displayName: "Test \(name)"
            )
            
            XCTAssertEqual(
                fhirResource.date?.timeIntervalSince1970,
                testDate.timeIntervalSince1970,
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
        
        let jsonData = jsonString.data(using: .utf8)!
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
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedObservation = try decoder.decode(ModelsDSTU2.Observation.self, from: jsonData)
        
        XCTAssertEqual(decodedObservation.id, observation.id)
        XCTAssertEqual(decodedObservation.code, observation.code)
        XCTAssertEqual(decodedObservation.status, observation.status)
    }
    
    func testMatchesDisplayName() throws {
        let observation = try ModelsR4Mocks.createObservation(date: testDate)
        
        let resource = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test Resource"
        )
        
        XCTAssertTrue(resource.matchesDisplayName(with: "test"))
        XCTAssertTrue(resource.matchesDisplayName(with: "resource"))
        XCTAssertTrue(resource.matchesDisplayName(with: "  test  "))
        XCTAssertTrue(resource.matchesDisplayName(with: "TEST"))
        XCTAssertFalse(resource.matchesDisplayName(with: "xyz"))
        XCTAssertFalse(resource.matchesDisplayName(with: ""))
    }
    
    func testFilterByDisplayName() throws {
        let observation = try ModelsR4Mocks.createObservation(date: testDate)
        let patient = try ModelsR4Mocks.createPatient(date: testDate)
        let medicationRequest = try ModelsR4Mocks.createMedicationRequest(date: testDate)
        
        let resource1 = FHIRResource(
            versionedResource: .r4(observation),
            displayName: "Test Resource1"
        )
        
        let resource2 = FHIRResource(
            versionedResource: .r4(patient),
            displayName: "Test Resource2"
        )
        
        let resource3 = FHIRResource(
            versionedResource: .r4(medicationRequest),
            displayName: "Test Resource3"
        )
        
        let resources = [resource1, resource2, resource3]
        
        XCTAssertEqual(resources.filterByDisplayName(with: "test").count, 3)
        XCTAssertEqual(resources.filterByDisplayName(with: "resource1").count, 1)
        XCTAssertEqual(resources.filterByDisplayName(with: "xyz").count, 0)
        XCTAssertEqual(resources.filterByDisplayName(with: "").count, 3)
    }
    
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

private extension FHIRResourceTests {
    func assertEqualDates(_ resourceDate: Date?, _ expectedDate: Date, _ resourceName: String) {
        guard let resourceDate = resourceDate else {
            XCTFail("Date should not be nil for \(resourceName)")
            return
        }
        
        // For resources that use FHIRDate (like Patient birthDate), compare only date components
        if resourceName == "Patient" {
            let testComponents = calendar.dateComponents([.year, .month, .day], from: expectedDate)
            let resourceComponents = calendar.dateComponents([.year, .month, .day], from: resourceDate)
            
            XCTAssertEqual(
                testComponents.year,
                resourceComponents.year,
                "Year mismatch for \(resourceName)"
            )
            XCTAssertEqual(
                testComponents.month,
                resourceComponents.month,
                "Month mismatch for \(resourceName)"
            )
            XCTAssertEqual(
                testComponents.day,
                resourceComponents.day,
                "Day mismatch for \(resourceName)"
            )
        } else {
            // For other resources using DateTime/Instant, compare exact timestamps
            XCTAssertEqual(
                resourceDate.timeIntervalSince1970,
                expectedDate.timeIntervalSince1970,
                "Date extraction failed for \(resourceName)"
            )
        }
    }
}

private struct ModelsR4Mocks {
    static func createCarePlan(date: Date) throws -> ModelsR4.CarePlan {
        let period = ModelsR4.Period()
        period.start = try FHIRPrimitive(DateTime(date: date))
        
        return ModelsR4.CarePlan(
            id: "care-plan-id".asFHIRStringPrimitive(),
            intent: FHIRPrimitive(.plan),
            period: period,
            status: FHIRPrimitive(.active),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createCareTeam(date: Date) throws -> ModelsR4.CareTeam {
        let period = ModelsR4.Period()
        period.start = try FHIRPrimitive(DateTime(date: date))
        
        return ModelsR4.CareTeam(
            id: "care-team-id".asFHIRStringPrimitive(),
            period: period,
            status: FHIRPrimitive(.active)
        )
    }
    
    static func createClaim(date: Date) throws -> ModelsR4.Claim {
        let period = ModelsR4.Period()
        period.end = try FHIRPrimitive(DateTime(date: date))
        
        return ModelsR4.Claim(
            billablePeriod: period,
            created: FHIRPrimitive(try DateTime(date: .now)),
            id: "claim-id".asFHIRStringPrimitive(),
            insurance: [
                ClaimInsurance(
                    coverage: Reference(id: "coverage-id".asFHIRStringPrimitive()),
                    focal: FHIRPrimitive<ModelsR4.FHIRBool>(true),
                    sequence: FHIRPrimitive<ModelsR4.FHIRPositiveInteger>(1)
                )
            ],
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            priority: CodeableConcept(
                coding: [
                    Coding(code: "normal".asFHIRStringPrimitive())
                ]
            ),
            provider: Reference(id: "provider-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active),
            type: CodeableConcept(
                coding: [
                    Coding(code: "type".asFHIRStringPrimitive())
                ]
            ),
            use: FHIRPrimitive(.claim)
        )
    }
    
    static func createCondition(date: Date) throws -> ModelsR4.Condition {
        return ModelsR4.Condition(
            id: "condition-id".asFHIRStringPrimitive(),
            onset: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createDevice(date: Date) throws -> ModelsR4.Device {
        return ModelsR4.Device(
            id: "device-id".asFHIRStringPrimitive(),
            manufactureDate: FHIRPrimitive(try DateTime(date: date))
        )
    }
    
    static func createDiagnosticReport(date: Date) throws -> ModelsR4.DiagnosticReport {
        return ModelsR4.DiagnosticReport(
            code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
            effective: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            id: "diagnostic-report-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
    }
    
    static func createDocumentReference(date: Date) throws -> ModelsR4.DocumentReference {
        let content = ModelsR4.DocumentReferenceContent(
            attachment: Attachment(
                contentType: "text/plain".asFHIRStringPrimitive()
            )
        )
        
        return ModelsR4.DocumentReference(
            content: [content],
            date: FHIRPrimitive(try Instant(date: date)),
            id: "document-reference-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.current)
        )
    }
    
    static func createEncounter(date: Date) throws -> ModelsR4.Encounter {
        let period = ModelsR4.Period()
        period.end = try FHIRPrimitive(DateTime(date: date))
        
        return ModelsR4.Encounter(
            class: Coding(
                code: "AMB".asFHIRStringPrimitive(),
                system: FHIRPrimitive<FHIRURI>("http://terminology.hl7.org/CodeSystem/v3-ActCode")
            ),
            id: "encounter-id".asFHIRStringPrimitive(),
            period: period,
            status: FHIRPrimitive(.finished)
        )
    }
    
    static func createExplanationOfBenefit(date: Date) throws -> ModelsR4.ExplanationOfBenefit {
        let period = ModelsR4.Period()
        period.end = try FHIRPrimitive(DateTime(date: date))
        
        return ModelsR4.ExplanationOfBenefit(
            billablePeriod: period,
            created: FHIRPrimitive(try DateTime(date: .now)),
            id: "explanation-of-benefit-id".asFHIRStringPrimitive(),
            insurance: [
                ExplanationOfBenefitInsurance(
                    coverage: Reference(id: "coverage-id".asFHIRStringPrimitive()),
                    focal: FHIRPrimitive(true)
                )
            ],
            insurer: Reference(id: "insurer-id".asFHIRStringPrimitive()),
            outcome: FHIRPrimitive(.complete),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            provider: Reference(id: "provider-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active),
            type: CodeableConcept(
                coding: [
                    Coding(code: "type".asFHIRStringPrimitive())
                ]
            ),
            use: FHIRPrimitive(.claim)
        )
    }
    
    static func createImmunization(date: Date) throws -> ModelsR4.Immunization {
        return ModelsR4.Immunization(
            id: "immunization-id".asFHIRStringPrimitive(),
            occurrence: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept(
                coding: [
                    Coding(code: "vaccine-code".asFHIRStringPrimitive())
                ]
            )
        )
    }
    
    static func createMedicationRequest(date: Date) throws -> ModelsR4.MedicationRequest {
        return ModelsR4.MedicationRequest(
            authoredOn: FHIRPrimitive(try DateTime(date: date)),
            id: "medication-request-id".asFHIRStringPrimitive(),
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.active),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createMedicationAdministration(date: Date) throws -> ModelsR4.MedicationAdministration {
        return ModelsR4.MedicationAdministration(
            effective: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            id: "medication-administration-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createObservation(date: Date) throws -> ModelsR4.Observation {
        return ModelsR4.Observation(
            code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
            id: "observation-id".asFHIRStringPrimitive(),
            issued: FHIRPrimitive(try Instant(date: date)),
            status: FHIRPrimitive(.final)
        )
    }
    
    static func createProcedure(date: Date) throws -> ModelsR4.Procedure {
        return ModelsR4.Procedure(
            id: "procedure-id".asFHIRStringPrimitive(),
            performed: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }

    static func createPatient(date: Date) throws -> ModelsR4.Patient {
        return ModelsR4.Patient(
            birthDate: FHIRPrimitive(try FHIRDate(date: date)),
            id: "patient-id".asFHIRStringPrimitive()
        )
    }
    
    static func createProvenance(date: Date) throws -> ModelsR4.Provenance {
        return ModelsR4.Provenance(
            agent: [
                ProvenanceAgent(
                    type: CodeableConcept(
                        coding: [Coding(code: "agent-type".asFHIRStringPrimitive())]
                    ),
                    who: Reference(id: "agent-id".asFHIRStringPrimitive())
                )
            ],
            id: "provenance-id".asFHIRStringPrimitive(),
            recorded: FHIRPrimitive(try Instant(date: date)),
            target: [
                Reference(id: "target-id".asFHIRStringPrimitive())
            ]
        )
    }
    
    static func createSupplyDelivery(date: Date) throws -> ModelsR4.SupplyDelivery {
        return ModelsR4.SupplyDelivery(
            id: "supply-delivery-id".asFHIRStringPrimitive(),
            occurrence: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            status: FHIRPrimitive(.completed)
        )
    }
}


private struct ModelsDSTU2Mocks {
    static func createObservation(date: Date) throws -> ModelsDSTU2.Observation {
        return ModelsDSTU2.Observation(
            code: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            ),
            id: "observation-id".asFHIRStringPrimitive(),
            issued: FHIRPrimitive(try Instant(date: date)),
            status: FHIRPrimitive(.final)
        )
    }
    
    static func createMedicationOrder(date: Date) throws -> ModelsDSTU2.MedicationOrder {
        return ModelsDSTU2.MedicationOrder(
            dateWritten: FHIRPrimitive(try DateTime(date: date)),
            id: "medication-order-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.active)
        )
    }
    
    static func createMedicationStatement(date: Date) throws -> ModelsDSTU2.MedicationStatement {
        return ModelsDSTU2.MedicationStatement(
            effective: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            id: "medication-statement-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active)
        )
    }
    
    static func createCondition(date: Date) throws -> ModelsDSTU2.Condition {
        return ModelsDSTU2.Condition(
            code: CodeableConcept(
                coding: [
                    Coding(code: "condition-code".asFHIRStringPrimitive())
                ]
            ),
            id: "condition-id".asFHIRStringPrimitive(),
            onset: .dateTime(FHIRPrimitive(try DateTime(date: date))),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            verificationStatus: FHIRPrimitive(.confirmed)
        )
    }
    
    static func createProcedure(date: Date, usePeriod: Bool = false) throws -> ModelsDSTU2.Procedure {
        let period = ModelsDSTU2.Period()
        period.end = try FHIRPrimitive(DateTime(date: date))
        
        let performed: ModelsDSTU2.Procedure.PerformedX = usePeriod ?
            .period(period) :
            .dateTime(FHIRPrimitive(try DateTime(date: date)))
        
        return ModelsDSTU2.Procedure(
            code: CodeableConcept(
                coding: [
                    Coding(code: "procedure-code".asFHIRStringPrimitive())
                ]
            ),
            id: "procedure-id".asFHIRStringPrimitive(),
            performed: performed,
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
}

