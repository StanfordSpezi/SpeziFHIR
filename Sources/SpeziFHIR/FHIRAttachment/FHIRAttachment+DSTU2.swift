//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import UniformTypeIdentifiers


extension ModelsDSTU2.Attachment: FHIRAttachment {
    public var debugDescription: String {
        """
        Could not transform attachement type: \(title?.primitiveDescription ?? "No title") to a string representation.
        
        Attachement: \(id?.primitiveDescription ?? "No ID")
            Creation Date: \(creation?.primitiveDescription ?? "No Creation")
            MIME Type: \(mimeType?.preferredMIMEType ?? "No Content Type")
        """
    }
    
    public var mimeType: UTType? {
        guard let mimeTypeString = contentType?.value?.string,
              !mimeTypeString.isEmpty else {
            return nil
        }
        return UTType(mimeType: mimeTypeString)
    }
    
    public var base64String: String? {
        data?.value?.dataString
    }

    public func encode(content: String) {
        data = FHIRPrimitive(ModelsDSTU2.Base64Binary(content))
    }
}
