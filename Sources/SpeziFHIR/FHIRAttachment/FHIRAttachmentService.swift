//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import UniformTypeIdentifiers


/// Service to handle FHIR attachment content extraction.
struct FHIRAttachmentService {
    private let contentExtractors: [any ContentExtractor]
    private let base64Decoder: any Base64Decoding


    /// Creates a new attachment service instance.
    /// - Parameters:
    ///   - contentExtractors: Collection of content extractors to use (defaults to text and PDF).
    ///   - base64Decoder: The base64 decoder to use.
    init(
        contentExtractors: [any ContentExtractor] = [TextContentExtractor(), PDFContentExtractor()],
        base64Decoder: any Base64Decoding = DefaultBase64Decoder()
    ) {
        self.contentExtractors = contentExtractors
        self.base64Decoder = base64Decoder
    }


    /// Transforms a FHIR attachment's base64-encoded data into human-readable text.
    ///
    /// This method extracts text content from various attachment formats (PDF, text files, etc.)
    /// based on their MIME type and replaces the original binary content with the extracted text,
    /// re-encoded as base64 to maintain FHIR data structure compatibility.
    ///
    /// - Parameter attachment: The FHIR attachment to transform.
    /// - Throws: `FHIRAttachmentError` if the transformation fails for any reason,
    ///           such as missing MIME type, invalid base64 data, or unsupported content type.
    func stringify(attachment: some FHIRAttachment) throws {
        let content = try processAttachment(attachment)
        attachment.encode(content: content)
    }

    private func processAttachment(_ attachment: some FHIRAttachment) throws -> String {
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

    private func contentExtractor(for contentType: UTType) -> (any ContentExtractor)? {
         contentExtractors.first { extractor in
             extractor.isCompatible(with: contentType)
         }
    }
}
