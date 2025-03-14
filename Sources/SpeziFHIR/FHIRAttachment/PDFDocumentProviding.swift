//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PDFKit


/// Protocol for creating PDFDocument objects - makes testing possible.
protocol PDFDocumentProviding {
    /// Creates a PDF document from raw data.
    /// - Parameter data: The PDF data to create a document from.
    /// - Returns: A PDFDocument if valid, nil otherwise.
    func createPDFDocument(from data: Data) -> PDFDocument?
}

/// Default implementation using the PDFDocument class from PDFKit.
struct DefaultPDFDocumentProvider: PDFDocumentProviding {
    func createPDFDocument(from data: Data) -> PDFDocument? {
        PDFDocument(data: data)
    }
}

