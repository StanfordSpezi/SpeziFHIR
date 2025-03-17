//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2


enum ModelsDSTU2Mocks { // swiftlint:disable:this type_body_length
    static func createAllergyIntolerance() -> ModelsDSTU2.AllergyIntolerance {
        ModelsDSTU2.AllergyIntolerance(
            id: "allergy-intolerance-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            substance: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            )
        )
    }
    
    static func createDiagnosticOrder() -> ModelsDSTU2.DiagnosticOrder {
        ModelsDSTU2.DiagnosticOrder(
            id: "diagnostic-order-id".asFHIRStringPrimitive(),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createDiagnosticReport(date: Date? = nil) throws -> ModelsDSTU2.DiagnosticReport {
        ModelsDSTU2.DiagnosticReport(
            code: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            ),
            effective: .dateTime(FHIRPrimitive(try DateTime(date: date ?? Date()))),
            id: "diagnostic-report-id".asFHIRStringPrimitive(),
            issued: FHIRPrimitive(try Instant(date: date ?? Date())),
            performer: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.final),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }

    static func createObservation(issuedDate: Date? = nil, effectiveDate: Date? = nil) throws -> ModelsDSTU2.Observation {
        let observation = ModelsDSTU2.Observation(
            code: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            ),
            id: "observation-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
        if let issuedDate {
            observation.issued = FHIRPrimitive(try Instant(date: issuedDate))
        } else if let effectiveDate {
            observation.effective = .dateTime(FHIRPrimitive(try DateTime(date: effectiveDate)))
        }
        return observation
    }
    
    static func createImmunization() -> ModelsDSTU2.Immunization {
        ModelsDSTU2.Immunization(
            id: "immunization-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            reported: FHIRPrimitive(true),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            ),
            wasNotGiven: FHIRPrimitive(true)
        )
    }
    
    static func createImmunizationRecommendation() -> ModelsDSTU2.ImmunizationRecommendation {
        ModelsDSTU2.ImmunizationRecommendation(
            id: "immunization-recommendation-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            recommendation: []
        )
    }
    
    static func createMedication() -> ModelsDSTU2.Medication {
        ModelsDSTU2.Medication(id: "medication-id".asFHIRStringPrimitive())
    }
    
    static func createMedicationAdministration(date: Date? = nil) throws -> ModelsDSTU2.MedicationAdministration {
        ModelsDSTU2.MedicationAdministration(
            effectiveTime: .dateTime(FHIRPrimitive(try DateTime(date: date ?? Date()))),
            id: "medication-administration-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.completed)
        )
    }
    
    static func createMedicationDispense() -> ModelsDSTU2.MedicationDispense {
        ModelsDSTU2.MedicationDispense(
            id: "medication-dispense-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.completed)
        )
    }
    
    static func createMedicationOrder(date: Date? = nil) throws -> ModelsDSTU2.MedicationOrder {
        let medicationOrder = ModelsDSTU2.MedicationOrder(
            id: "medication-order-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.active)
        )
        if let date = date {
            medicationOrder.dateWritten = FHIRPrimitive(try DateTime(date: date))
        }
        return medicationOrder
    }
    
    static func createMedicationStatement(date: Date? = nil) throws -> ModelsDSTU2.MedicationStatement {
        let medicationStatement = ModelsDSTU2.MedicationStatement(
            id: "medication-statement-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active)
        )
        if let date = date {
            medicationStatement.effective = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return medicationStatement
    }
    
    static func createCondition(date: Date? = nil) throws -> ModelsDSTU2.Condition {
        let condition = ModelsDSTU2.Condition(
            code: CodeableConcept(
                coding: [
                    Coding(code: "condition-code".asFHIRStringPrimitive())
                ]
            ),
            id: "condition-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            verificationStatus: FHIRPrimitive(.confirmed)
        )
        if let date = date {
            condition.onset = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return condition
    }
    
    static func createEncounter() -> ModelsDSTU2.Encounter {
        ModelsDSTU2.Encounter(id: "encounter-id".asFHIRStringPrimitive(), status: FHIRPrimitive(.finished))
    }
    
    static func createProcedure(date: Date? = nil, usePeriod: Bool = false) throws -> ModelsDSTU2.Procedure {
        let procedure = ModelsDSTU2.Procedure(
            code: CodeableConcept(
                coding: [
                    Coding(code: "procedure-code".asFHIRStringPrimitive())
                ]
            ),
            id: "procedure-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
        if let date = date {
            let period = ModelsDSTU2.Period()
            period.end = try FHIRPrimitive(DateTime(date: date))
            
            let performed: ModelsDSTU2.Procedure.PerformedX = usePeriod ?
                .period(period) :
                .dateTime(FHIRPrimitive(try DateTime(date: date)))
            
            procedure.performed = performed
        }
        return procedure
    }
    
    static func createProcedureRequest() -> ModelsDSTU2.ProcedureRequest {
        ModelsDSTU2.ProcedureRequest(
            code: CodeableConcept(
                coding: [
                    Coding(code: "procedure-code".asFHIRStringPrimitive())
                ]
            ),
            id: "procedure-id".asFHIRStringPrimitive(),
            performer: Reference(id: "performer-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }

    static func createAttachment(
        id: String,
        title: String,
        contentType: String,
        content: String,
        creation: Date? = nil
    ) throws -> ModelsDSTU2.Attachment {
        let attachment = ModelsDSTU2.Attachment(
            contentType: FHIRPrimitive(stringLiteral: contentType),
            data: FHIRPrimitive(ModelsDSTU2.Base64Binary(content)),
            id: id.asFHIRStringPrimitive(),
            title: FHIRPrimitive(ModelsDSTU2.FHIRString(title))
        )

        if let creation {
            attachment.creation = FHIRPrimitive(try DateTime(date: creation))
        }

        return attachment
    }

    static func createDocumentReference(
        id: String = "document-reference-id",
        status: ModelsDSTU2.DocumentReferenceStatus = .current,
        type: ModelsDSTU2.CodeableConcept? = nil,
        attachments: [ModelsDSTU2.Attachment] = [],
        created: Date? = nil
    ) throws -> ModelsDSTU2.DocumentReference {
        let documentType = type ?? CodeableConcept(
            coding: [
                Coding(
                    code: "34108-1".asFHIRStringPrimitive(),
                    display: "Outpatient Note".asFHIRStringPrimitive(),
                    system: "http://mock.org".asFHIRURIPrimitive()
                )
            ]
        )

        let contentItems = attachments.map { attachment in
            ModelsDSTU2.DocumentReferenceContent(attachment: attachment)
        }

        let indexedInstant = FHIRPrimitive(try Instant(date: Date()))

        let documentReference = ModelsDSTU2.DocumentReference(
            content: contentItems,
            indexed: indexedInstant,
            status: FHIRPrimitive(status),
            type: documentType
        )

        documentReference.id = id.asFHIRStringPrimitive()

        if let created {
            documentReference.created = FHIRPrimitive(try DateTime(date: created))
        }

        return documentReference
    }

    static func createTextAttachment(
        id: String = "text-attachment-id",
        title: String = "Text Attachment",
        creationDate: Date? = nil
    ) throws -> ModelsDSTU2.Attachment {
        // This is a minimal base64-encoded text with the text "Welcome to SpeziFHIR"
        let textBase64 = "V2VsY29tZSB0byBTcGV6aUZISVI="

        return try createAttachment(
            id: id,
            title: title,
            contentType: "text/plain",
            content: textBase64,
            creation: creationDate
        )
    }

    static func createPDFAttachment(
        id: String = "pdf-attachment-id",
        title: String = "PDF Attachment",
        creation: Date? = nil
    ) throws -> ModelsDSTU2.Attachment {
        // This is a minimal base64-encoded PDF with the text "PDF: Welcome to SpeziFHIR"
        // swiftlint:disable:next line_length
        let pdfBase64 = "JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA0IDAgUiA+PiA+PiAvQ29udGVudHMgNSAwIFIgPj4KZW5kb2JqCjQgMCBvYmoKPDwgL1R5cGUgL0ZvbnQgL1N1YnR5cGUgL1R5cGUxIC9CYXNlRm9udCAvSGVsdmV0aWNhID4+CmVuZG9iago1IDAgb2JqCjw8IC9MZW5ndGggNDQgPj4Kc3RyZWFtCkJUCi9GMSAxNiBUZgo1MCA3MDAgVGQKKFBERjogV2VsY29tZSB0byBTcGV6aUZISVIpIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmCjAwMDAwMDAwMDkgMDAwMDAgbgowMDAwMDAwMDU4IDAwMDAwIG4KMDAwMDAwMDExNSAwMDAwMCBuCjAwMDAwMDAyMjkgMDAwMDAgbgowMDAwMDAwMjk1IDAwMDAwIG4KdHJhaWxlcgo8PCAvU2l6ZSA2IC9Sb290IDEgMCBSID4+CnN0YXJ0eHJlZgozOTEKJSVFT0Y="

        return try createAttachment(
            id: id,
            title: title,
            contentType: "application/pdf",
            content: pdfBase64,
            creation: creation
        )
    }

    static func createMixedDocumentReference(
        id: String = "mixed-document-id",
        created: Date? = nil
    ) throws -> ModelsDSTU2.DocumentReference {
        let textAttachment = try createTextAttachment()
        let pdfAttachment = try createPDFAttachment()

        return try createDocumentReference(
            id: id,
            attachments: [textAttachment, pdfAttachment],
            created: created
        )
    }
}
