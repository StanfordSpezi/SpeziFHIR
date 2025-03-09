//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PDFKit
import UniformTypeIdentifiers


/// Uniform interface for FHIR attachment types.
public protocol FHIRAttachement: AnyObject {
    /// Debug description of the attachment
    var debugDescription: String { get }
    /// Best effort parsing of the MIME type of the attachment.
    var mimeType: UTType? { get }
    /// Convenience property to get and set the Base64 string representation of the attachment data.
    var base64Data: String? { get set }
}


extension FHIRAttachement {
    /// Best effort function to transform the base64 data representatino of an ``FHIRAttachement`` to a string-based respresentation of the data type.
    ///
    /// This funcationality is especially useful if the data content is inspected for debug purposes or passing it ot a LLM component.
    public func stringifyAttachements() async throws {
        // We inject the data right in the resource if it has the same content type.
        // There are a few shortcomings of this appraoch:
        // 1. We assume that the content type is a MIME type, we would need to more checks around the content.format to be fully correct.
        // 2. The data property expects a Base64 encoded String. This is according to the FHIR spec but we don't check this in detail here.
        guard let contentType = mimeType,
              let base64String = base64Data,
              let data = Data(base64Encoded: base64String) else {
            return
        }
        
        if contentType.conforms(to: .text) {
            base64Data = String(decoding: data, as: UTF8.self)
        } else if contentType.conforms(to: .pdf) {
            guard let pdf = PDFDocument(data: data) else {
                return
            }
            
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()
            
            for pageNumber in 0 ..< pageCount {
                guard let page = pdf.page(at: pageNumber) else {
                    continue
                }
                guard let pageContent = page.attributedString else {
                    continue
                }
                documentContent.append(pageContent)
            }
            
            base64Data = documentContent.string
        } else {
            print(debugDescription)
        }
    }
}
