//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension Period {
    var date: Date? {
        if let endDate = try? end?.value?.asNSDate() {
            return endDate
        }
        if let startDate = try? start?.value?.asNSDate() {
            return startDate
        }
        return nil
    }
}
