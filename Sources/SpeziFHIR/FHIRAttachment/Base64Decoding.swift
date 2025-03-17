//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


// swiftlint:disable file_types_order
/// Protocol for base64 decoding - makes testing possible.
protocol Base64Decoding {
    /// Decodes a base64 string to Data.
    /// - Parameter string: The base64 encoded string to decode.
    /// - Returns: Decoded data or nil if invalid.
    func decode(string: String) -> Data?
}

/// Default implementation using standard Data initializer.
struct DefaultBase64Decoder: Base64Decoding {
    func decode(string: String) -> Data? {
        Data(base64Encoded: string)
    }
}
