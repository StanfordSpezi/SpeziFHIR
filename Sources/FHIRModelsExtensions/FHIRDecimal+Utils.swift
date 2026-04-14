//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import Foundation
public import ModelsR4


extension FHIRDecimal {
    /// An error that can occur when creating a `FHIRDecimal`.
    public enum ConversionError: Error {
        /// Attempted to create a `FHIRDecimal` from an infinity value, which is not supported.
        case infinityInput
    }
}


extension Decimal {
    /// Converts the `Decimal` into a `Double`
    @inlinable public var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
    
    /// Converts the `Decimal` into an `Int`, possibly rounding if necessary
    @inlinable public var intValue: Int {
        NSDecimalNumber(decimal: self).intValue
    }
}


extension Double {
    /// Safe alternative to `asFHIRDecimalPrimitive()`, that throws an error if the other call would crash.
    @inlinable
    public func asFHIRDecimalPrimitiveSafe() throws(FHIRDecimal.ConversionError) -> FHIRPrimitive<FHIRDecimal> {
        // The `asFHIRDecimalPrimitive()` call below will trap if the input is infinity,
        // since Foundation.Decimal/NSDecimal/NSDecimalNumber (which the FHIRDecimal uses under the hood)
        // don't (yet; see FB22387018) support infinities.
        guard !isInfinite else {
            throw .infinityInput
        }
        return self.asFHIRDecimalPrimitive()
    }
}
