//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import UniformTypeIdentifiers


extension ModelsR4.Attachment: FHIRAttachement {
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
    
    public var base64Data: String? {
        get {
            data?.value?.dataString
        }
        set {
            guard let newValue else {
                data = nil
                return
            }
            data = FHIRPrimitive(ModelsR4.Base64Binary(newValue))
        }
    }
}
