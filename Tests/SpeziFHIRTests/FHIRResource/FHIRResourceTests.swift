//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2
import ModelsR4
@testable @_spi(Testing) import SpeziFHIR
import Testing


@Suite
struct FHIRResourceTests {
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


    @Test
    func testModelsR4ResourceInitialization() throws {
        let mockObservation = try ModelsR4Mocks.createObservation(issuedDate: Self.testDate)

        let resource = FHIRResource(
            resource: mockObservation,
            displayName: "Test Observation"
        )
        
        #expect(resource.id.fhirResourceId == "observation-id")
        #expect(resource.displayName == "Test Observation")
        #expect(resource.resourceType == "Observation")
    }

    @Test
    func testModelsDSTU2ResourceInitialization() throws {
        let mockObservation = try ModelsDSTU2Mocks.createObservation(issuedDate: Self.testDate)

        let resource = FHIRResource(
            resource: mockObservation,
            displayName: "Test Observation"
        )
        
        #expect(resource.id.fhirResourceId == "observation-id")
        #expect(resource.displayName == "Test Observation")
        #expect(resource.resourceType == "Observation")
    }

    @Test
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
        
        #expect(decodedObservation.id == observation.id)
        #expect(decodedObservation.code == observation.code)
        #expect(decodedObservation.status == observation.status)
    }
    
    @Test
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
        
        #expect(decodedObservation.id == observation.id)
        #expect(decodedObservation.code == observation.code)
        #expect(decodedObservation.status == observation.status)
    }
}
