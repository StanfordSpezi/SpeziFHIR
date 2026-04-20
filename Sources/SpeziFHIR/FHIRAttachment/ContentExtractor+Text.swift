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


/// Extractor for plain text content types.
struct TextContentExtractor: ContentExtractor {
    func isCompatible(with contentType: UTType) -> Bool {
        contentType.conforms(to: .text)
    }
    
    func extractContent(from data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw FHIRAttachmentError.textDecodingFailed
        }
        return string
    }
}

#endif
