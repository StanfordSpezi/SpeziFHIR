//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4
@testable import SpeziFHIR
import Testing
import UniformTypeIdentifiers

@Suite("FHIR Resource Attachment Stringification")
struct FHIRResourceStringifyTests {
    private let service = FHIRAttachmentService()

    // MARK: - R4 Tests

    @Test("R4 text attachment should be properly stringified")
    func testR4TextAttachmentStringification() throws {
        let attachment = try ModelsR4Mocks.createTextAttachment()
        let docRef = try ModelsR4Mocks.createDocumentReference(attachments: [attachment])
        let resource = FHIRResource(versionedResource: .r4(docRef), displayName: "Text Document")

        let originalBase64 = attachment.base64String

        try resource.stringifyAttachements(using: service)

        let transformedContent = attachment.base64String

        #expect(transformedContent != nil)
        #expect(transformedContent != originalBase64, "Content should be transformed")
        #expect(transformedContent == "Welcome to SpeziFHIR", "Content should now be human-readable")
    }

    @Test("R4 PDF attachment should extract text content")
    func testR4PDFAttachmentStringification() throws {
        let pdfAttachment = try ModelsR4Mocks.createPDFAttachment()
        let docRef = try ModelsR4Mocks.createDocumentReference(attachments: [pdfAttachment])
        let resource = FHIRResource(versionedResource: .r4(docRef), displayName: "PDF Document")

        let originalBase64 = pdfAttachment.base64String

        try resource.stringifyAttachements(using: service)

        let transformedContent = pdfAttachment.base64String

        #expect(transformedContent != nil)
        #expect(transformedContent != originalBase64, "Content should be transformed")
        #expect(transformedContent == "PDF: Welcome to SpeziFHIR", "Extracted content should contain PDF text")
    }

    @Test("R4 document with mixed attachments should process all attachments")
    func testR4MixedAttachmentsProcessing() throws {
        let docRef = try ModelsR4Mocks.createMixedDocumentReference()
        let resource = FHIRResource(versionedResource: .r4(docRef), displayName: "Mixed Document")

        let originalContents = docRef.content.compactMap { $0.attachment.base64String }

        try resource.stringifyAttachements(using: service)

        let transformedContents = docRef.content.compactMap { $0.attachment.base64String }

        for (index, originalContent) in originalContents.enumerated() {
            #expect(transformedContents[index] != originalContent, "Attachment \(index) should be transformed")
        }
    }

    @Test("Empty document reference should process no attachments")
    func testEmptyDocumentReferenceProcessesNoAttachments() throws {
        let docRef = try ModelsR4Mocks.createDocumentReference(attachments: [])
        let resource = FHIRResource(versionedResource: .r4(docRef), displayName: "Empty Document")

        try resource.stringifyAttachements(using: service)

        #expect(docRef.content.isEmpty, "Content array should remain empty")
    }

    // MARK: - DSTU2 Tests

    @Test("DSTU2 text attachment should be properly stringified")
    func testDSTU2TextAttachmentStringification() throws {
        let attachment = try ModelsDSTU2Mocks.createTextAttachment()
        let docRef = try ModelsDSTU2Mocks.createDocumentReference(attachments: [attachment])
        let resource = FHIRResource(versionedResource: .dstu2(docRef), displayName: "DSTU2 Document")

        let originalBase64 = attachment.base64String

        try resource.stringifyAttachements(using: service)

        let transformedContent = attachment.base64String
        #expect(transformedContent != nil)
        #expect(transformedContent != originalBase64, "Content should be transformed")
        #expect(transformedContent == "Welcome to SpeziFHIR", "Content should now be human-readable")
    }

    @Test("DSTU2 PDF attachment should extract text content")
    func testDSTU2PDFAttachmentStringification() throws {
        // Arrange - Create a document with a PDF attachment
        let pdfAttachment = try ModelsDSTU2Mocks.createPDFAttachment()
        let docRef = try ModelsDSTU2Mocks.createDocumentReference(attachments: [pdfAttachment])
        let resource = FHIRResource(versionedResource: .dstu2(docRef), displayName: "DSTU2 PDF Document")

        let originalBase64 = pdfAttachment.base64String

        try resource.stringifyAttachements(using: service)

        let transformedContent = pdfAttachment.base64String
        #expect(transformedContent != nil)
        #expect(transformedContent != originalBase64, "Content should be transformed")

        // The PDF content should now contain "PDF: Welcome to SpeziFHIR" text from the mock PDF
        #expect(transformedContent == "PDF: Welcome to SpeziFHIR", "Extracted content should contain PDF text")
    }
}
