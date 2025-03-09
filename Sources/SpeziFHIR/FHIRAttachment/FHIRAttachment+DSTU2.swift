//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import UniformTypeIdentifiers


extension ModelsDSTU2.Attachment: FHIRAttachement {
    public var debugDescription: String {
        """
        Could not transform attachement type: \(title?.primitiveDescription ?? "No title") to a string representation.
        
        Attachement: \(id?.primitiveDescription ?? "No ID")
            Creation Date: \(creation?.primitiveDescription ?? "No Creation")
            MIME Type: \(mimeType?.preferredMIMEType ?? "No Content Type")
        """
    }
    
    public var mimeType: UTType? {
        UTType(mimeType: contentType?.value?.string ?? "")
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
            data = FHIRPrimitive(ModelsDSTU2.Base64Binary(newValue))
        }
    }
}
