//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import FHIRModelsExtensions
import Foundation
import ModelsR4
import Testing


@MainActor // to work around https://github.com/apple/FHIRModels/issues/36
struct TimeZoneTests {
    /// Tests creating a `Period` instance using different time zones for start and end date.
    @Test
    func multiTimeZonePeriod() throws {
        let timeZoneLA = try #require(TimeZone(identifier: "America/Los_Angeles"))
        let timeZoneDE = try #require(TimeZone(identifier: "Europe/Berlin"))
        
        // we're choosing this exact date bc at that point in time, LA was already in DST, while germany was not.
        let startDateLA = try #require(Calendar.current.date(from: .init(timeZone: timeZoneLA, year: 2025, month: 3, day: 14, hour: 7)))
        let startDateDE = try #require(Calendar.current.date(from: .init(timeZone: timeZoneDE, year: 2025, month: 3, day: 14, hour: 15)))
        let endDateLA = try #require(Calendar.current.date(from: .init(timeZone: timeZoneLA, year: 2025, month: 3, day: 14, hour: 7, minute: 30)))
        let endDateDE = try #require(Calendar.current.date(from: .init(timeZone: timeZoneDE, year: 2025, month: 3, day: 14, hour: 15, minute: 30)))
        
        #expect(try DateTime(date: startDateLA, timeZone: timeZoneLA).asNSDate() == DateTime(date: startDateDE, timeZone: timeZoneDE).asNSDate())
        
        #expect(try DateTime(date: endDateLA, timeZone: timeZoneLA).asNSDate() == DateTime(date: endDateDE, timeZone: timeZoneDE).asNSDate())
        
        let period1 = Period(
            end: FHIRPrimitive(try DateTime(date: startDateLA, timeZone: timeZoneLA)),
            start: FHIRPrimitive(try DateTime(date: endDateDE, timeZone: timeZoneDE))
        )
        let period2 = Period(
            end: FHIRPrimitive(try DateTime(date: startDateDE, timeZone: timeZoneDE)),
            start: FHIRPrimitive(try DateTime(date: endDateLA, timeZone: timeZoneLA))
        )
        
        #expect(try #require(period1.start?.value).asNSDate() == #require(period2.start?.value).asNSDate())
        #expect(try #require(period1.end?.value).asNSDate() == #require(period2.end?.value).asNSDate())
    }
}
