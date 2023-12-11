//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension Procedure.PerformedX {
    var date: Date? {
        switch self {
        case let .dateTime(date):
            return try? date.value?.asNSDate()
        case let .period(period):
            return period.date
        case .age:
            return nil
        case .range:
            return nil
        case .string:
            return nil
        }
    }
}
