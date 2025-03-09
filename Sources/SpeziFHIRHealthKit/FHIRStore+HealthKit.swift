//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import HealthKitOnFHIR
import ModelsDSTU2
import ModelsR4
import PDFKit
import SpeziFHIR
import SpeziHealthKit


extension FHIRStore {
    /// Indicates if the FHIR store should load attachement documents from clinical health record data when transform HKSamples to FHIR documents.
    @MainActor public static var loadHealthKitAttachements: Bool = false
    
    private static let hkHealthStore: HKHealthStore? = {
        guard HKHealthStore.isHealthDataAvailable() else {
            return nil
        }
        
        return HKHealthStore()
    }()
    
    
    /// Add a HealthKit sample to the FHIR store.
    /// - Parameter sample: The sample that should be added.
    public func add(sample: HKSample) async {
        do {
            var resource = try await transform(sample: sample)
            if await Self.loadHealthKitAttachements, let hkHealthStore = Self.hkHealthStore {
                try await resource.loadAttachements(from: sample, store: hkHealthStore)
            }
            await insert(resource: resource)
        } catch {
            print("Could not transform HKSample: \(error)")
        }
    }
    
    /// Remove a HealthKit sample delete object from the FHIR store.
    /// - Parameter sample: The sample delete object that should be removed.
    public func remove(sample: HKDeletedObject) async {
        await remove(resource: sample.uuid.uuidString)
    }
    
    
    private func transform(sample: HKSample) async throws -> FHIRResource {
        switch sample {
        case let clinicalResource as HKClinicalRecord where clinicalResource.fhirResource?.fhirVersion == .primaryDSTU2():
            guard let fhirResource = clinicalResource.fhirResource else {
                throw HealthKitOnFHIRError.invalidFHIRResource
            }
            
            let decoder = JSONDecoder()
            let resourceProxy = try decoder.decode(ModelsDSTU2.ResourceProxy.self, from: fhirResource.data)
            let fhirModelResource = resourceProxy.get()
            
            return FHIRResource(
                versionedResource: .dstu2(fhirModelResource),
                displayName: clinicalResource.displayName
            )
        case let clinicalResource as HKClinicalRecord:
            let fhirModelResource = try clinicalResource.resource.get()
            
            return FHIRResource(
                versionedResource: .r4(fhirModelResource),
                displayName: clinicalResource.displayName
            )
        case let electrocardiogram as HKElectrocardiogram:
            guard let hkHealthStore = Self.hkHealthStore else {
                fallthrough
            }
            
            async let symptoms = try electrocardiogram.symptoms(from: hkHealthStore)
            async let voltageMeasurements = try electrocardiogram.voltageMeasurements(from: hkHealthStore)
            
            let electrocardiogramResource = try await electrocardiogram.observation(
                symptoms: symptoms,
                voltageMeasurements: voltageMeasurements
            )
            return FHIRResource(
                versionedResource: .r4(electrocardiogramResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(electrocardiogramResource.id?.value?.string ?? "-")")
            )
        default:
            let genericResource = try sample.resource.get()
            return FHIRResource(
                versionedResource: .r4(genericResource),
                displayName: String(localized: "FHIR_RESOURCES_SUMMARY_ID_TITLE \(genericResource.id?.value?.string ?? "-")")
            )
        }
    }
}

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
