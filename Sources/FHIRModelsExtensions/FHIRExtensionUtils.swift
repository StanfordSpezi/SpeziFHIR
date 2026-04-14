//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import ModelsR4


extension ModelsR4.Extension.ValueX {
    /// The value's string value, if applicable.
    public var stringValue: FHIRPrimitive<FHIRString>? {
        switch self {
        case .string(let value):
            value
        default:
            nil
        }
    }
}
