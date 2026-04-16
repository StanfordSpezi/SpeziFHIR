//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
public import ModelsR4


extension FHIRExtensionURL {
    /// Url of a FHIR Extension containing, if applicable, the absolute start date timestamp of a FHIR `Observation`.
    public static let absoluteTimeRangeStart = Self("https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeStart")
    
    /// Url of a FHIR Extension containing, if applicable, the absolute end date timestamp of a FHIR `Observation`.
    public static let absoluteTimeRangeEnd = Self("https://bdh.stanford.edu/fhir/defs/absoluteTimeRangeEnd")
}


extension Observation {
    /// Writes the Observation's absolute effective start and end date into a FHIR Extension.
    ///
    /// The absolute timestamps (decimals representing the time interval since 1970) are stored using the ``FHIRExtensionURL/absoluteTimeRangeStart`` and ``FHIRExtensionURL/absoluteTimeRangeEnd`` urls.
    ///
    /// - throws: If an error was encountered when converting the effective time range into the extension values. If the Observation's effecrive time uses an unsupported format (eg: `Timing`), ``HealthKitOnFHIRError/notSupported`` is thrown.
    public mutating func encodeAbsoluteTimeRangeIntoExtension() throws {
        removeAllExtensions(withUrl: .absoluteTimeRangeStart)
        removeAllExtensions(withUrl: .absoluteTimeRangeEnd)
        let startDate, endDate: DateTime?
        switch effective {
        case nil:
            return
        case .dateTime(let dateTime):
            startDate = dateTime.value
            endDate = dateTime.value
        case .period(let period):
            startDate = period.start?.value
            endDate = period.end?.value
        case .instant(let instant):
            startDate = try instant.value.flatMap { try DateTime(instant: $0) }
            endDate = startDate
        case .timing:
            throw NSError(domain: "edu.stanford.Spezi.FHIRModelsExtensions", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Not supported"
            ])
        }
        if let startDate = try startDate?.asNSDate() {
            append(
                extension: Extension(
                    url: .absoluteTimeRangeStart,
                    value: .decimal(startDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
                ),
                behaviour: .replace
            )
        }
        if let endDate = try endDate?.asNSDate() {
            append(
                extension: Extension(
                    url: .absoluteTimeRangeEnd,
                    value: .decimal(endDate.timeIntervalSince1970.asFHIRDecimalPrimitive())
                ),
                behaviour: .replace
            )
        }
    }
}
