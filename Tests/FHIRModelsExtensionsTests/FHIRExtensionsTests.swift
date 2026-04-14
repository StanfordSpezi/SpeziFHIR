//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import FHIRModelsExtensions
import Foundation
import ModelsR4
import Testing


@MainActor
struct FHIRExtensionsTests {
    @Test
    func dateTimeUtils() throws {
        let timeZone = try #require(TimeZone(identifier: "Europe/Berlin"))
        let date = try #require(Calendar.current.date(
            from: .init(timeZone: timeZone, year: 2025, month: 07, day: 09, hour: 12, minute: 24)
        ))
        let instant = try Instant(date: date, timeZone: timeZone)
        let dateTime1 = try DateTime(date: date, timeZone: timeZone)
        let dateTime2 = try DateTime(instant: instant)
        #expect(dateTime1 == dateTime2)
    }
    
    
    @Test
    func fhirDateUtils() throws {
        let timeZone = try #require(TimeZone(identifier: "Europe/Berlin"))
        let date = try #require(Calendar.current.date(
            from: .init(timeZone: timeZone, year: 2025, month: 07, day: 09, hour: 12, minute: 24)
        ))
        let instantDate = InstantDate(year: 2025, month: 07, day: 09)
        let fhirDate1 = try FHIRDate(date: date, timeZone: timeZone)
        let fhirDate2 = FHIRDate(instantDate: instantDate)
        let fhirDate3 = FHIRDate(year: 2025, month: 07, day: 09)
        #expect(fhirDate1 == fhirDate2)
        #expect(fhirDate1 == fhirDate3)
    }
    
    
    @Test
    func decimalHandling() {
        #expect(Decimal(Double.nan).doubleValue.isNaN)
        #expect(Decimal(Double.signalingNaN).doubleValue.isNaN)
        
        #expect(throws: FHIRDecimal.ConversionError.infinityInput) {
            try (+Double.infinity).asFHIRDecimalPrimitiveSafe()
        }
        #expect(throws: FHIRDecimal.ConversionError.infinityInput) {
            try (-Double.infinity).asFHIRDecimalPrimitiveSafe()
        }
        #expect(throws: Never.self) {
            _ = try Double.nan.asFHIRDecimalPrimitiveSafe()
            _ = try Double.signalingNaN.asFHIRDecimalPrimitiveSafe()
        }
    }
}
