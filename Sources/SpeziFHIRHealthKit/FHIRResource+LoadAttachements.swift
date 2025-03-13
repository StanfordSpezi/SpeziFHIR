//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
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
        guard category == .document || category == .diagnostic else {
            return
        }
        
        // We inject the data right in the resource if it has the same content type.
        // There are a few shortcomings of this appraoch:
        // 1. We assume that the content type is a MIME type, we would need to more checks around the content.format to be fully correct.
        // 2. The data property actually expects a Base64 encoded String. We currently just inject a normal string.
        // Otherwise we create a new content entry to inject this information in here.
        switch versionedResource {
        case let .r4(r4Resource):
            try await loadAttachementsForR4(forR4Resource: r4Resource, from: healthKitSample, store: store)
        case let .dstu2(dstu2Resource):
            try await loadAttachementsForDSTU2(forDSTU2Resource: dstu2Resource, from: healthKitSample, store: store)
        }
    }
    
    
    private func loadAttachementsForR4(
        forR4Resource r4Resource: ModelsR4.Resource,
        from healthKitSample: HKSample,
        store: HKHealthStore = HKHealthStore()
    ) async throws {
        if let documentReference = r4Resource as? ModelsR4.DocumentReference {
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsR4.Base64Binary(textEncodedAttachement.base64EncodedString))
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
        } else if let diagnosticReport = r4Resource as? ModelsR4.DiagnosticReport {
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsR4.Base64Binary(textEncodedAttachement.base64EncodedString))
                if let attachment = (diagnosticReport.presentedForm ?? []).first(
                       where: { $0.contentType?.value?.string == textEncodedAttachement.identifier }
                   ),
                   attachment.data == nil {
                    attachment.data = data
                } else {
                    if diagnosticReport.presentedForm == nil {
                        diagnosticReport.presentedForm = []
                    }
                    
                    diagnosticReport.presentedForm?.append(
                        Attachment(contentType: FHIRPrimitive(stringLiteral: textEncodedAttachement.identifier), data: data)
                    )
                }
            }
        } else {
            print("Unexpected FHIR type in the document parsing path: \(r4Resource.description)")
        }
    }
    
    private func loadAttachementsForDSTU2(
        forDSTU2Resource dstu2Resource: ModelsDSTU2.Resource,
        from healthKitSample: HKSample,
        store: HKHealthStore = HKHealthStore()
    ) async throws {
        if let documentReference = dstu2Resource as? ModelsDSTU2.DocumentReference {
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsDSTU2.Base64Binary(textEncodedAttachement.base64EncodedString))
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
        } else if let diagnosticReport = dstu2Resource as? ModelsDSTU2.DiagnosticReport {
            for textEncodedAttachement in try await textEncodedAttachements(for: healthKitSample, hkHealthStore: store) {
                let data = FHIRPrimitive(ModelsDSTU2.Base64Binary(textEncodedAttachement.base64EncodedString))
                if let attachment = (diagnosticReport.presentedForm ?? []).first(
                       where: { $0.contentType?.value?.string == textEncodedAttachement.identifier }
                   ),
                   attachment.data == nil {
                    attachment.data = data
                } else {
                    if diagnosticReport.presentedForm == nil {
                        diagnosticReport.presentedForm = []
                    }
                    
                    diagnosticReport.presentedForm?.append(
                        Attachment(contentType: FHIRPrimitive(stringLiteral: textEncodedAttachement.identifier), data: data)
                    )
                }
            }
        } else {
            print("Unexpected FHIR type in the document parsing path: \(dstu2Resource.description)")
        }
    }
    
    private func textEncodedAttachements(
        for healthKitSample: HKSample,
        hkHealthStore: HKHealthStore = HKHealthStore()
    ) async throws -> [(identifier: String, base64EncodedString: String)] {
        try await withThrowingTaskGroup(of: (String, String).self, returning: [(String, String)].self) { taskGroup in
            let attachmentStore = HKAttachmentStore(healthStore: hkHealthStore)
            let attachments = try await attachmentStore.attachments(for: healthKitSample)
            
            for attachment in attachments {
                taskGroup.addTask {
                    let mimeType = attachment.contentType.preferredMIMEType ?? attachment.contentType.identifier
                    let dataReader = attachmentStore.dataReader(for: attachment)
                    return (mimeType, try await dataReader.data.base64EncodedString())
                }
            }
            
            var base64Attachments: [(String, String)] = []
            while let base64Attachment = try await taskGroup.next() {
                base64Attachments.append(base64Attachment)
            }
            return base64Attachments
        }
    }
}


extension HKAttachmentStore: @retroactive @unchecked Sendable {}
