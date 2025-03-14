//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PDFKit
import UniformTypeIdentifiers


/// Uniform interface for FHIR attachment types.
protocol FHIRAttachment: AnyObject {
    /// Debug description of the attachment.
    var debugDescription: String { get }

    /// Best effort parsing of the MIME type of the attachment.
    /// Represents the content type of the attachment data (e.g., text/plain, application/pdf).
    var mimeType: UTType? { get }

    /// Convenience property to get and set the Base64 string representation of the attachment data.
    var base64String: String? { get }

    /// Encodes the provided string content into the FHIR attachment.
    /// - Parameter content: The string content to encode into the FHIR  attachment.
    func encode(content: String)
}

/// Errors thrown while interacting with FHIR attachment types.
enum FHIRAttachmentError: Error, Equatable {
    /// The attachment does not have a valid MIME type.
    case missingMimeType

    /// The attachment does not contain any base64-encoded string.
    case missingBase64String

    /// The base64 string couldn't be decoded into valid binary data.
    case invalidBase64Data

    /// The text data couldn't be decoded using UTF-8 encoding.
    case textDecodingFailed

    /// The data couldn't be parsed as a valid PDF document.
    case pdfParsingFailed

    /// The content type is not supported by any available extractor.
    case unsupportedContentType(UTType)
}
