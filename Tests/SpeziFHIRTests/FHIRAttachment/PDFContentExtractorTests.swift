//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@testable import SpeziFHIR
import PDFKit
import Testing
import UniformTypeIdentifiers


@Suite struct PDFContentExtractorTests {
    @Test("Successfully extracts text from PDF with single page")
    func testPDFSinglePageTextExtraction() throws {
        let expectedText = "This is test content for PDF extraction"
        let mockPage = MockPDFPage(text: expectedText)
        let mockPDFDocument = MockPDFDocument(pages: [mockPage])

        let pdfProvider = MockPDFDocumentProvider(result: .success(mockPDFDocument))
        let extractor = PDFContentExtractor(pdfDocumentProvider: pdfProvider)

        let extracted = try extractor.extractContent(from: Data())

        #expect(extracted == expectedText)
    }

    @Test("Successfully extracts and combines text from multi-page PDF")
    func testPDFMultiPageTextExtraction() throws {
        let page1Text = "Page 1 text"
        let page2Text = "Page 2 text"
        let page3Text = "Page 3 text"

        let mockPages = [
            MockPDFPage(text: page1Text),
            MockPDFPage(text: page2Text),
            MockPDFPage(text: page3Text)
        ]

        let mockPDFDocument = MockPDFDocument(pages: mockPages)
        let mockPDFProvider = MockPDFDocumentProvider(result: .success(mockPDFDocument))
        let extractor = PDFContentExtractor(pdfDocumentProvider: mockPDFProvider)

        let extracted = try extractor.extractContent(from: Data())

        #expect(extracted.contains(page1Text))
        #expect(extracted.contains(page2Text))
        #expect(extracted.contains(page3Text))
    }

    @Test("Successfully extracts text from PDF with missing pages")
    func testPDFWithMissingPages() throws {
        let mockPDFDocument = MockPartialPagesPDFDocument()
        let mockPDFProvider = MockPDFDocumentProvider(result: .success(mockPDFDocument))
        let extractor = PDFContentExtractor(pdfDocumentProvider: mockPDFProvider)

        let extracted = try extractor.extractContent(from: Data())

        #expect(extracted.contains("Page 1 content"))
        #expect(!extracted.contains("Page 2 content"))
        #expect(extracted.contains("Page 3 content"))
    }

    @Test("Throws error when PDF parsing fails")
    func testPDFParsingFailure() throws {
        let mockPDFProvider = MockPDFDocumentProvider(result: .failure)
        let extractor = PDFContentExtractor(pdfDocumentProvider: mockPDFProvider)

        do {
            _ = try extractor.extractContent(from: Data())
        } catch let error as FHIRAttachmentError {
            #expect(error == .pdfParsingFailed)
        }
    }

    @Test("Correctly identifies compatible content types")
    func testCompatibleContentTypes() {
        let extractor = PDFContentExtractor()

        #expect(extractor.isCompatible(with: UTType(mimeType: "application/pdf")!))
        #expect(!extractor.isCompatible(with: UTType(mimeType: "text/plain")!))
    }
}

private struct MockPDFDocumentProvider: PDFDocumentProviding {
    enum Result {
        case success(PDFDocument)
        case failure
    }

    let result: Result

    func createPDFDocument(from data: Data) -> PDFDocument? {
        switch result {
        case .success(let document):
            return document
        case .failure:
            return nil
        }
    }
}


private class MockPDFPage: PDFPage {
    private let mockAttributedString: NSAttributedString

    init(text: String) {
        self.mockAttributedString = NSAttributedString(string: text)
        super.init()
    }

    override var attributedString: NSAttributedString? {
        return mockAttributedString
    }
}

private class MockPDFDocument: PDFDocument {
    private var mockPages: [MockPDFPage]

    init(pages: [MockPDFPage]) {
        self.mockPages = pages
        super.init()
    }

    override var pageCount: Int {
        return mockPages.count
    }

    override func page(at index: Int) -> PDFPage? {
        guard index >= 0 && index < mockPages.count else {
            return nil
        }
        return mockPages[index]
    }
}

private class MockPartialPagesPDFDocument: PDFDocument {
    override var pageCount: Int { return 3 }

    override func page(at index: Int) -> PDFPage? {
        if index == 1 {
            return nil
        }
        return MockPDFPage(text: "Page \(index + 1) content")
    }
}
