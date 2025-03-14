//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UniformTypeIdentifiers


/// Service to handle FHIR attachment content extraction.
public struct FHIRAttachmentService {
    private let contentExtractors: [ContentExtractor]
    private let base64Decoder: Base64Decoding


    /// Creates a new attachment service instance.
    /// - Parameters:
    ///   - contentExtractors: Collection of content extractors to use (defaults to text and PDF).
    ///   - base64Decoder: The base64 decoder to use.
    public init(
        contentExtractors: [ContentExtractor] = [TextContentExtractor(), PDFContentExtractor()],
        base64Decoder: Base64Decoding = DefaultBase64Decoder()
    ) {
        self.contentExtractors = contentExtractors
        self.base64Decoder = base64Decoder
    }


    /// Processes an attachment and converts its binary content to a readable string.
    /// - Parameter attachment: The FHIR attachment to process.
    /// - Returns: Extracted content as a string.
    /// - Throws: FHIRAttachmentError if processing fails.
    public func processAttachment(_ attachment: FHIRAttachment) throws -> String {
        guard let contentType = attachment.mimeType else {
            throw FHIRAttachmentError.missingMimeType
        }

        guard let encodedString = attachment.base64String else {
            throw FHIRAttachmentError.missingBase64String
        }

        guard let data = base64Decoder.decode(string: encodedString) else {
            throw FHIRAttachmentError.invalidBase64Data
        }

        guard let extractor = contentExtractor(for: contentType) else {
            throw FHIRAttachmentError.unsupportedContentType(contentType)
        }

        let content = try extractor.extractContent(from: data)
        return content
    }

    private func contentExtractor(for contentType: UTType) -> ContentExtractor? {
         contentExtractors.first { extractor in
             extractor.isCompatible(with: contentType)
         }
    }
}

