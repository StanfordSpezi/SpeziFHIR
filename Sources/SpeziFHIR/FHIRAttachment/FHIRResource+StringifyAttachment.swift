//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4


extension FHIRResource {
    func stringifyAttachements() async throws {
        switch versionedResource {
        case let .r4(r4Resource):
            guard let documentReference = r4Resource as? ModelsR4.DocumentReference else {
                return
            }
            
            for attachement in documentReference.content.compactMap(\.attachment) {
                try await attachement.stringifyAttachements()
            }
        case let .dstu2(dstu2Resource):
            guard let documentReference = dstu2Resource as? ModelsDSTU2.DocumentReference else {
                return
            }
            
            for attachement in documentReference.content.compactMap(\.attachment) {
                try await attachement.stringifyAttachements()
            }
        }
    }
}
