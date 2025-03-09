//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import ModelsDSTU2
import ModelsR4
import PDFKit
import SpeziFHIR


extension FHIRResource {
    mutating func loadAttachements(from healthKitSample: HKSample, store: HKHealthStore = HKHealthStore()) async throws {
        guard category == .document else {
            return
        }
        
        // We inject the data right in the resource if it has the same content type.
        // There are a few shortcomings of this appraoch:
        // 1. We assume that the content type is a MIME type, we would need to more checks around the content.format to be fully correct.
        // 2. The data property actually expects a Base64 encoded String. We currently just inject a normal string.
        // Otherwise we create a new content entry to inject this information in here.
        switch versionedResource {
        case let .r4(r4Resource):
            guard let documentReference = r4Resource as? ModelsR4.DocumentReference else {
                print("Unexpected FHIR type in the document parsing path: \(r4Resource.description)")
                return
            }
            
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsR4.Base64Binary(textEncodedAttachement.content))
                if let content = documentReference.content.first(
                       where: { $0.attachment.contentType?.value?.string == textEncodedAttachement.identifier }
                   ),
                   content.attachment.data == nil {
                    content.attachment.data = data
                } else {
                    documentReference.content.append(
                        DocumentReferenceContent(
                            attachment: Attachment(contentType: FHIRPrimitive(stringLiteral: textEncodedAttachement.identifier), data: data)
                        )
                    )
                }
            }
        case let .dstu2(dstu2Resource):
            guard let documentReference = dstu2Resource as? ModelsDSTU2.DocumentReference else {
                print("Unexpected FHIR type in the document parsing path: \(dstu2Resource.description)")
                return
            }
            
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsDSTU2.Base64Binary(textEncodedAttachement.content))
                if let content = documentReference.content.first(
                       where: { $0.attachment.contentType?.value?.string == textEncodedAttachement.identifier }
                   ),
                   content.attachment.data == nil {
                    content.attachment.data = data
                } else {
                    documentReference.content.append(
                        DocumentReferenceContent(
                            attachment: Attachment(contentType: FHIRPrimitive(stringLiteral: textEncodedAttachement.identifier), data: data)
                        )
                    )
                }
            }
        }
    }
    
    private func textEncodedAttachements(
        for healthKitSample: HKSample,
        hkHealthStore: HKHealthStore = HKHealthStore()
    ) async throws -> [(identifier: String, content: String)] {
        let attachmentStore = HKAttachmentStore(healthStore: hkHealthStore)
        let attachments = try await attachmentStore.attachments(for: healthKitSample)
        
        var strings: [(identifier: String, content: String)] = []
        
        for attachment in attachments {
            let dataReader = attachmentStore.dataReader(for: attachment)
            let mimeType = attachment.contentType.preferredMIMEType ?? attachment.contentType.identifier
            if attachment.contentType.conforms(to: .text) {
                let data = try await dataReader.data
                strings.append((mimeType, String(decoding: data, as: UTF8.self)))
            } else if attachment.contentType.conforms(to: .pdf) {
                let data = try await dataReader.data
                if let pdf = PDFDocument(data: data) {
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
                    
                    strings.append((mimeType, documentContent.string))
                }
            } else {
                print(
                    """
                    Could not transform attachement type: \(attachment.contentType) to a string representation.
                    
                    Attachement: \(attachment.identifier)
                        Name: \(attachment.name)
                        Creation Date: \(attachment.creationDate)
                        Size: \(attachment.size)
                        Content Type: \(attachment.contentType)
                    """
                )
            }
        }
        
        return strings
    }
}
