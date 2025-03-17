//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PDFKit
@testable import SpeziFHIR
import Testing
import UniformTypeIdentifiers


private final class MockFHIRAttachment: FHIRAttachment {
    var debugDescription: String = "Mock FHIR Attachment"
    var mimeType: UTType?
    var base64String: String?
    var encodedContent: String?

    func encode(content: String) {
        encodedContent = content
    }
}

@Suite
struct FHIRAttachmentServiceTests {
    @Test("Successfully stringifies text content")
    func testStringifyTextContent() throws {
        let base64Decoder = DefaultBase64Decoder()
        let textType = UTType(mimeType: "text/plain")
        let textContentExtractor = TextContentExtractor()

        let service = FHIRAttachmentService(
            contentExtractors: [textContentExtractor],
            base64Decoder: base64Decoder
        )

        let attachment = MockFHIRAttachment()
        attachment.mimeType = textType
        attachment.base64String = "V2VsY29tZSB0byBTcGV6aUZISVI="

        try service.stringify(attachment: attachment)

        #expect(attachment.encodedContent == "Welcome to SpeziFHIR")
    }

    @Test("Successfully stringifies PDF content")
   func testStringifyPDFContent() throws {
       let base64Decoder = DefaultBase64Decoder()
       let pdfType = UTType(mimeType: "application/pdf")
       let pdfContentExtractor = PDFContentExtractor(pdfDocumentProvider: DefaultPDFDocumentProvider())

       let service = FHIRAttachmentService(
           contentExtractors: [pdfContentExtractor],
           base64Decoder: base64Decoder
       )

        let attachment = MockFHIRAttachment()
        attachment.mimeType = pdfType
        // swiftlint:disable:next line_length
        attachment.base64String = "JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA0IDAgUiA+PiA+PiAvQ29udGVudHMgNSAwIFIgPj4KZW5kb2JqCjQgMCBvYmoKPDwgL1R5cGUgL0ZvbnQgL1N1YnR5cGUgL1R5cGUxIC9CYXNlRm9udCAvSGVsdmV0aWNhID4+CmVuZG9iago1IDAgb2JqCjw8IC9MZW5ndGggNDQgPj4Kc3RyZWFtCkJUCi9GMSAxNiBUZgo1MCA3MDAgVGQKKFBERjogV2VsY29tZSB0byBTcGV6aUZISVIpIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmCjAwMDAwMDAwMDkgMDAwMDAgbgowMDAwMDAwMDU4IDAwMDAwIG4KMDAwMDAwMDExNSAwMDAwMCBuCjAwMDAwMDAyMjkgMDAwMDAgbgowMDAwMDAwMjk1IDAwMDAwIG4KdHJhaWxlcgo8PCAvU2l6ZSA2IC9Sb290IDEgMCBSID4+CnN0YXJ0eHJlZgozOTEKJSVFT0Y="

       try service.stringify(attachment: attachment)

       #expect(attachment.encodedContent == "PDF: Welcome to SpeziFHIR")
   }

    @Test("Throws error when MIME type is missing")
    func testMissingMimeType() throws {
        let service = FHIRAttachmentService()

        let attachment = MockFHIRAttachment()
        attachment.mimeType = nil
        attachment.base64String = "V2VsY29tZSB0byBTcGV6aUZISVI="

        do {
            try service.stringify(attachment: attachment)
        } catch let error as FHIRAttachmentError {
            #expect(error == .missingMimeType)
        }
    }

    @Test("Throws error when base64 string is missing")
    func testMissingBase64String() throws {
        let service = FHIRAttachmentService()

        let attachment = MockFHIRAttachment()
        attachment.mimeType = UTType(mimeType: "text/plain")
        attachment.base64String = nil

        do {
            try service.stringify(attachment: attachment)
        } catch let error as FHIRAttachmentError {
            #expect(error == .missingBase64String)
        }
    }

    @Test("Throws error when base64 data is invalid")
    func testInvalidBase64Data() throws {
        let base64Decoder = DefaultBase64Decoder()
        let service = FHIRAttachmentService(base64Decoder: base64Decoder)

        let attachment = MockFHIRAttachment()
        attachment.mimeType = UTType(mimeType: "text/plain")
        attachment.base64String = "invalid-base64-string"

        do {
            try service.stringify(attachment: attachment)
        } catch let error as FHIRAttachmentError {
            #expect(error == .invalidBase64Data)
        }
    }

    @Test("Throws error when content type is unsupported")
    func testUnsupportedContentType() throws {
        let base64Decoder = DefaultBase64Decoder()
        let textContextExtractor = TextContentExtractor()
        let service = FHIRAttachmentService(
            contentExtractors: [textContextExtractor],
            base64Decoder: base64Decoder
        )

        let customType = UTType(mimeType: "application/custom")
        let attachment = MockFHIRAttachment()
        attachment.mimeType = customType
        attachment.base64String = "V2VsY29tZSB0byBTcGV6aUZISVI="

        do {
            try service.stringify(attachment: attachment)
        } catch let error as FHIRAttachmentError {
            if let customType = customType {
                #expect(error == .unsupportedContentType(customType))
            }
        }
    }

    @Test("Throws error when no extractors are available")
    func testServiceWithEmptyExtractors() throws {
        let mockDecoder = DefaultBase64Decoder()
        let service = FHIRAttachmentService(
            contentExtractors: [],
            base64Decoder: mockDecoder
        )

        let textPlainType = UTType(mimeType: "text/plain")
        let attachment = MockFHIRAttachment()
        attachment.mimeType = textPlainType
        attachment.base64String = "SGVsbG8sIHdvcmxkIQ=="

        do {
            try service.stringify(attachment: attachment)
        } catch let error as FHIRAttachmentError {
            if let textPlainType = textPlainType {
                #expect(error == .unsupportedContentType(textPlainType))
            } else {
                Issue.record("Expected textPlainType to be non-nil to verify error type")
            }
        }
    }
}
