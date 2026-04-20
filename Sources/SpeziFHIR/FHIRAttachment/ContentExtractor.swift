//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(UniformTypeIdentifiers)

import Foundation
import UniformTypeIdentifiers


/// Protocol for content extraction strategies.
protocol ContentExtractor {
    /// Determines if this extractor is compatible with the given content type.
    /// - Parameter contentType: The content type to check.
    /// - Returns: True if this extractor can handle the content type.
    func isCompatible(with contentType: UTType) -> Bool
    
    /// Extract readable content from data.
    /// - Parameter data: Binary data to extract content from.
    /// - Returns: Extracted text content.
    /// - Throws: Error if extraction fails.
    func extractContent(from data: Data) throws -> String
}

#endif
