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
    /// Best effort function to transform the base64 data representatino of any ``FHIRAttachement`` to a string-based respresentation of the data type.
    ///
    /// This funcationality is especially useful if the data content is inspected for debug purposes or passing it ot a LLM component.
    public func stringifyAttachements() throws {
        try stringifyAttachements(using: FHIRAttachmentService())
    }

    func stringifyAttachements(using service: FHIRAttachmentService) throws {
        switch versionedResource {
        case let .r4(r4Resource):
            guard let documentReference = r4Resource as? ModelsR4.DocumentReference else {
                return
            }
            
            for attachement in documentReference.content.compactMap(\.attachment) {
                try service.stringify(attachment: attachement)
            }
        case let .dstu2(dstu2Resource):
            guard let documentReference = dstu2Resource as? ModelsDSTU2.DocumentReference else {
                return
            }
            
            for attachement in documentReference.content.compactMap(\.attachment) {
                try service.stringify(attachment: attachement)
            }
        }
    }
}
