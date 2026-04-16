//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import FHIRModelsExtensions
import Foundation
import ModelsR4
import Testing


@Suite
struct ObservationExtensionsTests {
    @Test
    func collectionExtensionsIdentifier() throws {
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.append(identifier: Identifier(id: "ID1"))
        
        // Assertions for the nil/non-present case:
        #expect(observation.identifier?.first == Identifier(id: "ID1"))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.append(identifiers: [
            Identifier(id: "ID2"),
            Identifier(id: "ID3")
        ])
        
        // Assertions for the non-nil collection case:
        #expect(observation.identifier == [
            Identifier(id: "ID1"),
            Identifier(id: "ID2"),
            Identifier(id: "ID3")
        ])
    }
    
    @Test
    func collectionExtensionsCoding() throws {
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.append(
            coding: Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            )
        )
        
        // Assertions for the nil/non-present case:
        #expect(observation.code.coding?.first == Coding(
            code: "Code1",
            display: "Display1",
            system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
        ))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.append(codings: [
            Coding(
                code: "Code2",
                display: "Display2",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test2.system"))
            ),
            Coding(
                code: "Code3",
                display: "Display3",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test3.system"))
            )
        ])
        
        // Assertions for the non-nil collection case:
        #expect(observation.code.coding == [
            Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            ),
            Coding(
                code: "Code2",
                display: "Display2",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test2.system"))
            ),
            Coding(
                code: "Code3",
                display: "Display3",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test3.system"))
            )
        ])
    }
    
    @Test
    func collectionExtensionsCategories() throws {
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.append(category: CodeableConcept(id: "Concept1"))
        
        // Assertions for the nil/non-present case:
        #expect(observation.category?.first == CodeableConcept(id: "Concept1"))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.append(categories: [
            CodeableConcept(id: "Concept2"),
            CodeableConcept(id: "Concept3")
        ])

        // Assertions for the non-nil collection case:
        #expect(observation.category == [
            CodeableConcept(id: "Concept1"),
            CodeableConcept(id: "Concept2"),
            CodeableConcept(id: "Concept3")
        ])
    }
    
    @Test
    func collectionExtensionsComponents() throws {
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.append(
            component: ObservationComponent(
                code: CodeableConcept(id: "Concept4"),
                value: .boolean(true.asPrimitive())
            )
        )
        
        // Assertions for the nil/non-present case:
        #expect(observation.component?.first == ObservationComponent(
            code: CodeableConcept(id: "Concept4"),
            value: .boolean(true.asPrimitive())
        ))
        
        
        // Now Append multiple elements and in a non-nil collection:
        observation.append(components: [
            ObservationComponent(
                code: CodeableConcept(id: "Concept5"),
                value: .string("Test".asFHIRStringPrimitive())
            ),
            ObservationComponent(
                code: CodeableConcept(id: "Concept6"),
                value: .integer(10.asFHIRIntegerPrimitive())
            )
        ])
        
        // Assertions for the non-nil collection case:
        #expect(observation.component == [
            ObservationComponent(
                code: CodeableConcept(id: "Concept4"),
                value: .boolean(true.asPrimitive())
            ),
            ObservationComponent(
                code: CodeableConcept(id: "Concept5"),
                value: .string("Test".asFHIRStringPrimitive())
            ),
            ObservationComponent(
                code: CodeableConcept(id: "Concept6"),
                value: .integer(10.asFHIRIntegerPrimitive())
            )
        ])
    }
    
    
    @Test
    func fhirExtension() throws {
        let extension1Url = FHIRExtensionURL("https://bdh.stanford.edu/fhir/testDef1")
        let extension2Url = FHIRExtensionURL("https://bdh.stanford.edu/fhir/testDef2")
        let extension1: (Int) -> Extension = { Extension(url: extension1Url, value: .integer($0.asFHIRIntegerPrimitive())) }
        let extension2: (Int) -> Extension = { Extension(url: extension2Url, value: .integer($0.asFHIRIntegerPrimitive())) }
        
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        #expect(observation.extension == nil)
        
        observation.append(extension: extension1(0), behaviour: .additive)
        #expect(observation.extension == [extension1(0)])
        
        observation.append(extension: extension2(0), behaviour: .additive)
        #expect(observation.extension == [extension1(0), extension2(0)])
        
        observation.append(extension: extension1(1), behaviour: .replace)
        #expect(observation.extension == [extension2(0), extension1(1)])
        
        observation.append(extension: extension1(2), behaviour: .additive)
        #expect(observation.extension == [extension2(0), extension1(1), extension1(2)])
        
        observation.append(extension: extension1(3), behaviour: .replace)
        #expect(observation.extension == [extension2(0), extension1(3)])
        
        observation.append(extension: extension2(1), behaviour: .additive)
        #expect(observation.extension == [extension2(0), extension1(3), extension2(1)])
        
        observation.append(extension: extension2(2), behaviour: .additive)
        #expect(observation.extension == [extension2(0), extension1(3), extension2(1), extension2(2)])
        
        observation.removeFirstExtension(withUrl: extension1Url)
        #expect(observation.extension == [extension2(0), extension2(1), extension2(2)])
        
        observation.removeFirstExtension(withUrl: extension2Url)
        #expect(observation.extension == [extension2(1), extension2(2)])
        
        observation.removeAllExtensions(withUrl: extension2Url)
        #expect(observation.extension == nil)
    }
    
    
    @Test
    func addObservationAbsoluteTimeRetroactively() throws {
        let cal = Calendar.current
        let startDate = try #require(cal.date(from: .init(year: 2025, month: 07, day: 09, hour: 12, minute: 31)))
        let endDate = try #require(cal.date(byAdding: .minute, value: 15, to: startDate))
        
        var observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        try observation.setEffective(startDate: startDate, endDate: endDate, timeZone: .current)
        #expect(observation.extension == nil)
        
        try observation.encodeAbsoluteTimeRangeIntoExtension()
        let extensions = try #require(observation.extension)
        #expect(extensions.count == 2)
        #expect(observation.extensions(for: .absoluteTimeRangeStart) == [
            Extension(url: .absoluteTimeRangeStart, value: .decimal(startDate.timeIntervalSince1970.asFHIRDecimalPrimitive()))
        ])
        #expect(observation.extensions(for: .absoluteTimeRangeEnd) == [
            Extension(url: .absoluteTimeRangeEnd, value: .decimal(endDate.timeIntervalSince1970.asFHIRDecimalPrimitive()))
        ])
    }
    
    
    @Test
    func voidExtensionBuilder() throws {
        let url = FHIRExtensionURL("https://bdh.stanford.edu/fhir/defs/timeZone")
        let timeZone = try #require(TimeZone(identifier: "Europe/Berlin"))
        let trackTimeZone = FHIRExtensionBuilder { (observation: inout Observation) in
            let ext = Extension(url: url, value: .string(timeZone.identifier.asFHIRStringPrimitive()))
            observation.append(extension: ext, behaviour: .replace)
        }
        var observation = Observation(code: CodeableConcept(), status: .init(.final))
        #expect(observation.extension == nil)
        try observation.apply(trackTimeZone)
        let exts = try #require(observation.extension)
        #expect(exts == [
            Extension(url: url, value: .string("Europe/Berlin".asFHIRStringPrimitive()))
        ])
    }
}
