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


enum FHIRModel {
    case dstu2
    case r4  // swiftlint:disable:this identifier_name

    var description: String {
        switch self {
        case .dstu2: return "DSTU2"
        case .r4: return "R4"
        }
    }
}

enum FHIRAttachmentTestHelper {
    static func createAttachment(model: FHIRModel) -> any FHIRAttachment {
        switch model {
        case .dstu2:
            return ModelsDSTU2.Attachment()
        case .r4:
            return ModelsR4.Attachment()
        }
    }

    static func createAttachmentWithContentType(_ contentType: String, model: FHIRModel) -> any FHIRAttachment {
        switch model {
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

    static func createAttachmentWithData(_ data: String, model: FHIRModel) -> any FHIRAttachment {
        switch model {
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

@Suite
struct FHIRAttachmentTests {
    @Test(
        "Attachment returns correct mime type",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testMimeType(_ model: FHIRModel) {
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithContentType("text/plain", model: model)
        let mimeType = attachment.mimeType

        #expect(mimeType != nil, "\(model.description) attachment should have non-nil MIME type")
        #expect(mimeType?.preferredMIMEType == "text/plain", "\(model.description) attachment should have correct MIME type")
    }

    @Test(
        "Attachment returns nil for empty mime type",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testEmptyMimeType(_ model: FHIRModel) {
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithContentType("", model: model)
        let mimeType = attachment.mimeType

        #expect(mimeType == nil, "\(model.description) attachment should return nil for empty MIME type")
    }

    @Test(
        "Attachment returns nil for missing mime type",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testMissingMimeType(_ model: FHIRModel) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(model: model)
        let mimeType = attachment.mimeType

        #expect(mimeType == nil, "\(model.description) attachment should return nil for missing MIME type")
    }

    @Test(
        "Attachment returns base64 string",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testBase64String(_ model: FHIRModel) {
        let testString = "Test content"
        let attachment = FHIRAttachmentTestHelper.createAttachmentWithData(testString, model: model)
        let base64String = attachment.base64String

        #expect(base64String == testString, "\(model.description) attachment should return correct base64 string")
    }

    @Test(
        "Attachment returns nil for missing base64 string",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testMissingBase64String(_ model: FHIRModel) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(model: model)
        let base64String = attachment.base64String

        #expect(base64String == nil, "\(model.description) attachment should return nil for missing base64 string")
    }

    @Test(
        "Attachment encodes content correctly",
        arguments: [FHIRModel.dstu2, FHIRModel.r4]
    )
    func testEncodeContent(_ model: FHIRModel) {
        let attachment = FHIRAttachmentTestHelper.createAttachment(model: model)
        let testContent = "This is test content"

        attachment.encode(content: testContent)

        #expect(attachment.base64String == testContent, "\(model.description) attachment should encode content correctly")
    }
}
