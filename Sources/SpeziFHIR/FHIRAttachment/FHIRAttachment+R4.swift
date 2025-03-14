//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import UniformTypeIdentifiers


extension ModelsR4.Attachment: FHIRAttachment {
    var debugDescription: String {
        """
        Could not transform attachement type: \(title?.primitiveDescription ?? "No title") to a string representation.
        
        Attachement: \(id?.primitiveDescription ?? "No ID")
            Creation Date: \(creation?.primitiveDescription ?? "No Creation")
            MIME Type: \(mimeType?.preferredMIMEType ?? "No Content Type")
        """
    }

    var mimeType: UTType? {
        guard let mimeTypeString = contentType?.value?.string,
              !mimeTypeString.isEmpty else {
            return nil
        }
        return UTType(mimeType: mimeTypeString)
    }
    
    var base64String: String? {
        data?.value?.dataString
    }

    func encode(content: String) {
        data = FHIRPrimitive(ModelsR4.Base64Binary(content))
    }
}
