//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4


extension FHIRResource {
    /// Best effort function to transform the base64 data representatino of any ``FHIRAttachment`` to a string-based respresentation of the data type.
    ///
    /// This funcationality is especially useful if the data content is inspected for debug purposes or passing it ot a LLM component.
    public func stringifyAttachments() throws {
        try stringifyAttachments(using: FHIRAttachmentService())
    }

    func stringifyAttachments(using service: FHIRAttachmentService) throws {
        switch versionedResource {
        case let .r4(r4Resource):
            guard let documentReference = r4Resource as? ModelsR4.DocumentReference else {
                return
            }
            
            for attachment in documentReference.content.compactMap(\.attachment) {
                try service.stringify(attachment: attachment)
            }
        case let .dstu2(dstu2Resource):
            guard let documentReference = dstu2Resource as? ModelsDSTU2.DocumentReference else {
                return
            }
            
            for attachment in documentReference.content.compactMap(\.attachment) {
                try service.stringify(attachment: attachment)
            }
        }
    }
}
