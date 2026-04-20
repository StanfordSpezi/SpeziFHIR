//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(PDFKit) && canImport(UniformTypeIdentifiers)

import Foundation
import PDFKit
import UniformTypeIdentifiers


/// Extractor for PDF document content types.
struct PDFContentExtractor<PDFProvider: PDFDocumentProviding>: ContentExtractor {
    private let pdfDocumentProvider: PDFProvider
    
    /// Creates a new instance of the PDF content extractor.
    /// - Parameter pdfDocumentProvider: The provider used to create PDFDocument instances.
    init(pdfDocumentProvider: PDFProvider = DefaultPDFDocumentProvider()) {
        self.pdfDocumentProvider = pdfDocumentProvider
    }
    
    func isCompatible(with contentType: UTType) -> Bool {
        contentType.conforms(to: .pdf)
    }
    
    func extractContent(from data: Data) throws -> String {
        guard let pdf = pdfDocumentProvider.createPDFDocument(from: data) else {
            throw FHIRAttachmentError.pdfParsingFailed
        }
        let documentContent = NSMutableAttributedString()
        for pageIdx in 0..<pdf.pageCount {
            guard let page = pdf.page(at: pageIdx), let content = page.attributedString else {
                continue
            }
            documentContent.append(content)
        }
        return documentContent.string
    }
}

#endif
