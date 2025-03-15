//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Testing
@testable import SpeziFHIR
import ModelsDSTU2
import ModelsR4
import UniformTypeIdentifiers


enum FHIRVersion {
    case dstu2
    case r4

    var description: String {
        switch self {
        case .dstu2: return "DSTU2"
        case .r4: return "R4"
        }
    }
}

struct FHIRAttachmentTestHelper {
    static func createAttachment(version: FHIRVersion) -> any FHIRAttachment {
        switch version {
        case .dstu2:
            return ModelsDSTU2.Attachment()
        case .r4:
            return ModelsR4.Attachment()
        }
    }

    static func createAttachmentWithContentType(_ contentType: String, version: FHIRVersion) -> any FHIRAttachment {
        switch version {
        case .dstu2:
            let attachment = ModelsDSTU2.Attachment()
            attachment.contentType = FHIRPrimitive(stringLiteral: contentType)
            return attachment
        case .r4:
            let attachment = ModelsR4.Attachment()
            attachment.contentType = FHIRPrimitive(stringLiteral: contentType)
            return attachment
        }
    }

    static func createAttachmentWithData(_ data: String, version: FHIRVersion) -> any FHIRAttachment {
        switch version {
        case .dstu2:
            let attachment = ModelsDSTU2.Attachment()
            attachment.data = FHIRPrimitive(ModelsDSTU2.Base64Binary(data))
            return attachment
        case .r4:
            let attachment = ModelsR4.Attachment()
            attachment.data = FHIRPrimitive(ModelsR4.Base64Binary(data))
            return attachment
        }
    }
}

@Suite struct FHIRAttachmentTests {

    @Test(
        "Attachment returns correct mime type",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testMimeType(_ version: FHIRVersion) {
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithContentType("text/plain", version: version)
        let mimeType = attachment.mimeType

        #expect(mimeType != nil, "\(version.description) attachment should have non-nil MIME type")
        #expect(mimeType?.preferredMIMEType == "text/plain", "\(version.description) attachment should have correct MIME type")
    }

    @Test(
        "Attachment returns nil for empty mime type",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testEmptyMimeType(_ version: FHIRVersion) {
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithContentType("", version: version)
        let mimeType = attachment.mimeType

        #expect(mimeType == nil, "\(version.description) attachment should return nil for empty MIME type")
    }

    @Test(
        "Attachment returns nil for missing mime type",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testMissingMimeType(_ version: FHIRVersion) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(version: version)
        let mimeType = attachment.mimeType

        #expect(mimeType == nil, "\(version.description) attachment should return nil for missing MIME type")
    }

    @Test(
        "Attachment returns base64 string",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testBase64String(_ version: FHIRVersion) {
        let testString = "Test content"
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithData(testString, version: version)
        let base64String = attachment.base64String

        #expect(base64String == testString, "\(version.description) attachment should return correct base64 string")
    }

    @Test(
        "Attachment returns nil for missing base64 string",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testMissingBase64String(_ version: FHIRVersion) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(version: version)
        let base64String = attachment.base64String

        #expect(base64String == nil, "\(version.description) attachment should return nil for missing base64 string")
    }

    @Test(
        "Attachment encodes content correctly",
        arguments: [FHIRVersion.dstu2, FHIRVersion.r4]
    )
    func testEncodeContent(_ version: FHIRVersion) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(version: version)
        let testContent = "This is test content"

        attachment.encode(content: testContent)

        #expect(attachment.base64String == testContent, "\(version.description) attachment should encode content correctly")
    }
}
