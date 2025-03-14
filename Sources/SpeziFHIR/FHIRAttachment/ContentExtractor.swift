//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PDFKit
import UniformTypeIdentifiers


/// Protocol for content extraction strategies.
public protocol ContentExtractor {
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

/// Extractor for plain text content types.
public struct TextContentExtractor: ContentExtractor {
    public init() {}


    public func isCompatible(with contentType: UTType) -> Bool {
        contentType.conforms(to: .text)
    }

    public func extractContent(from data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw FHIRAttachmentError.textDecodingFailed
        }
        return string
    }
}

/// Extractor for PDF document content types.
public struct PDFContentExtractor: ContentExtractor {
    private let pdfDocumentProvider: PDFDocumentProviding


    /// Creates a new instance of the PDF content extractor.
    /// - Parameter pdfDocumentProvider: The provider used to create PDFDocument instances.
    public init(pdfDocumentProvider: PDFDocumentProviding = DefaultPDFDocumentProvider()) {
        self.pdfDocumentProvider = pdfDocumentProvider
    }


    public func isCompatible(with contentType: UTType) -> Bool {
        contentType.conforms(to: .pdf)
    }

    public func extractContent(from data: Data) throws -> String {
        guard let pdf = pdfDocumentProvider.createPDFDocument(from: data) else {
            throw FHIRAttachmentError.pdfParsingFailed
        }

        let documentContent = NSMutableAttributedString()

        for pageNumber in 0 ..< pdf.pageCount {
            guard let page = pdf.page(at: pageNumber) else {
                continue
            }
            guard let pageContent = page.attributedString else {
                continue
            }
            documentContent.append(pageContent)
        }

        return documentContent.string
    }
}
