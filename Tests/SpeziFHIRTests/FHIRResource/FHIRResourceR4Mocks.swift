//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


enum ModelsR4Mocks { // swiftlint:disable:this type_body_length
    static func createAllergyIntolerance() -> ModelsR4.AllergyIntolerance {
        ModelsR4.AllergyIntolerance(
            id: "allergy-intolerance-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }

    static func createCarePlan(date: Date? = nil) throws -> ModelsR4.CarePlan {
        let period = ModelsR4.Period()
        if let date = date {
            period.start = try FHIRPrimitive(DateTime(date: date))
        }
        return ModelsR4.CarePlan(
            id: "care-plan-id".asFHIRStringPrimitive(),
            intent: FHIRPrimitive(.plan),
            period: period,
            status: FHIRPrimitive(.active),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createCareTeam(date: Date? = nil) throws -> ModelsR4.CareTeam {
        let period = ModelsR4.Period()
        if let date = date {
            period.start = try FHIRPrimitive(DateTime(date: date))
        }
        return ModelsR4.CareTeam(
            id: "care-team-id".asFHIRStringPrimitive(),
            period: period,
            status: FHIRPrimitive(.active)
        )
    }
    
    static func createClaim(date: Date? = nil) throws -> ModelsR4.Claim {
        let period = ModelsR4.Period()
        if let date = date {
            period.end = try FHIRPrimitive(DateTime(date: date))
        }
        return ModelsR4.Claim(
            billablePeriod: period,
            created: FHIRPrimitive(try DateTime(date: .now)),
            id: "claim-id".asFHIRStringPrimitive(),
            insurance: [
                ClaimInsurance(
                    coverage: Reference(id: "coverage-id".asFHIRStringPrimitive()),
                    focal: FHIRPrimitive<ModelsR4.FHIRBool>(true),
                    sequence: FHIRPrimitive<ModelsR4.FHIRPositiveInteger>(1)
                )
            ],
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            priority: CodeableConcept(
                coding: [
                    Coding(code: "normal".asFHIRStringPrimitive())
                ]
            ),
            provider: Reference(id: "provider-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active),
            type: CodeableConcept(
                coding: [
                    Coding(code: "type".asFHIRStringPrimitive())
                ]
            ),
            use: FHIRPrimitive(.claim)
        )
    }
    
    static func createCondition(date: Date? = nil) throws -> ModelsR4.Condition {
        let condition = ModelsR4.Condition(
            id: "condition-id".asFHIRStringPrimitive(),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
        if let date = date {
            condition.onset = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return condition
    }
    
    static func createDevice(date: Date) throws -> ModelsR4.Device {
        ModelsR4.Device(
            id: "device-id".asFHIRStringPrimitive(),
            manufactureDate: FHIRPrimitive(try DateTime(date: date))
        )
    }
    
    static func createDiagnosticReport(date: Date? = nil) throws -> ModelsR4.DiagnosticReport {
        let diagnosticReport = ModelsR4.DiagnosticReport(
            code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
            id: "diagnostic-report-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
        if let date = date {
            diagnosticReport.effective = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return diagnosticReport
    }
    
    static func createDocumentReference(date: Date? = nil) throws -> ModelsR4.DocumentReference {
        let content = ModelsR4.DocumentReferenceContent(
            attachment: Attachment(
                contentType: "text/plain".asFHIRStringPrimitive()
            )
        )
        let documentReference = ModelsR4.DocumentReference(
            content: [content],
            id: "document-reference-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.current)
        )
        if let date = date {
            documentReference.date = FHIRPrimitive(try Instant(date: date))
        }
        return documentReference
    }
    
    static func createEncounter(date: Date? = nil) throws -> ModelsR4.Encounter {
        let period = ModelsR4.Period()
        if let date = date {
            period.end = try FHIRPrimitive(DateTime(date: date))
        }
        return ModelsR4.Encounter(
            class: Coding(
                code: "AMB".asFHIRStringPrimitive(),
                system: FHIRPrimitive<FHIRURI>("http://terminology.hl7.org/CodeSystem/v3-ActCode")
            ),
            id: "encounter-id".asFHIRStringPrimitive(),
            period: period,
            status: FHIRPrimitive(.finished)
        )
    }
    
    static func createExplanationOfBenefit(date: Date? = nil) throws -> ModelsR4.ExplanationOfBenefit {
        let period = ModelsR4.Period()
        if let date = date {
            period.end = try FHIRPrimitive(DateTime(date: date))
        }
        return ModelsR4.ExplanationOfBenefit(
            billablePeriod: period,
            created: FHIRPrimitive(try DateTime(date: .now)),
            id: "explanation-of-benefit-id".asFHIRStringPrimitive(),
            insurance: [
                ExplanationOfBenefitInsurance(
                    coverage: Reference(id: "coverage-id".asFHIRStringPrimitive()),
                    focal: FHIRPrimitive(true)
                )
            ],
            insurer: Reference(id: "insurer-id".asFHIRStringPrimitive()),
            outcome: FHIRPrimitive(.complete),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            provider: Reference(id: "provider-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.active),
            type: CodeableConcept(
                coding: [
                    Coding(code: "type".asFHIRStringPrimitive())
                ]
            ),
            use: FHIRPrimitive(.claim)
        )
    }
    
    static func createImmunization(date: Date? = nil) throws -> ModelsR4.Immunization {
        ModelsR4.Immunization(
            id: "immunization-id".asFHIRStringPrimitive(),
            occurrence: .dateTime(FHIRPrimitive(try DateTime(date: date ?? FHIRResourceTests.testDate))),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept(
                coding: [
                    Coding(code: "vaccine-code".asFHIRStringPrimitive())
                ]
            )
        )
    }

    static func createImmunizationEvaluation() -> ModelsR4.ImmunizationEvaluation {
        ModelsR4.ImmunizationEvaluation(
            doseStatus: CodeableConcept(
                coding: [
                    Coding(code: "dose-status".asFHIRStringPrimitive())
                ]
            ),
            id: "immunization-eval-id".asFHIRStringPrimitive(),
            immunizationEvent: Reference(id: "event-id".asFHIRStringPrimitive()),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            status: FHIRPrimitive(.completed),
            targetDisease: CodeableConcept(
                coding: [
                    Coding(code: "targe-disease".asFHIRStringPrimitive())
                ]
            )
        )
    }
    
    static func createImmunizationRecommendation(date: Date? = nil) throws -> ModelsR4.ImmunizationRecommendation {
        ModelsR4.ImmunizationRecommendation(
            date: FHIRPrimitive(try DateTime(date: date ?? FHIRResourceTests.testDate)),
            id: "immunization-recommendation-id".asFHIRStringPrimitive(),
            patient: Reference(id: "patient-id".asFHIRStringPrimitive()),
            recommendation: []
        )
    }
    
    static func createMedication() -> ModelsR4.Medication {
        ModelsR4.Medication(id: "medication-id".asFHIRStringPrimitive())
    }
    
    static func createMedicationDispense() -> ModelsR4.MedicationDispense {
        ModelsR4.MedicationDispense(
            id: "medication-dispense-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.completed)
        )
    }
    
    static func createMedicationKnowledge() -> ModelsR4.MedicationKnowledge {
        ModelsR4.MedicationKnowledge(id: "medication-knowledge-id".asFHIRStringPrimitive())
    }
    
    static func createMedicationRequest(date: Date? = nil) throws -> ModelsR4.MedicationRequest {
        let medicationRequest = ModelsR4.MedicationRequest(
            id: "medication-request-id".asFHIRStringPrimitive(),
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.active),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
        if let date = date {
            medicationRequest.authoredOn = FHIRPrimitive(try DateTime(date: date))
        }
        return medicationRequest
    }
    
    static func createMedicationAdministration(date: Date? = nil) throws -> ModelsR4.MedicationAdministration {
        ModelsR4.MedicationAdministration(
            effective: .dateTime(FHIRPrimitive(try DateTime(date: date ?? FHIRResourceTests.testDate))),
            id: "medication-administration-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createMedicationStatement() -> ModelsR4.MedicationStatement {
        ModelsR4.MedicationStatement(
            id: "medication-statement-id".asFHIRStringPrimitive(),
            medication: .codeableConcept(
                CodeableConcept(coding: [
                    Coding(code: "med-code".asFHIRStringPrimitive())
                ])
            ),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
    }
    
    static func createObservation(issuedDate: Date? = nil, effectiveDate: Date? = nil) throws -> ModelsR4.Observation {
        let observation = ModelsR4.Observation(
            code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
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
    
    static func createObservationDefinition() -> ModelsR4.ObservationDefinition {
        ModelsR4.ObservationDefinition(
            code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
            id: "observation-definition-id".asFHIRStringPrimitive()
        )
    }
    
    static func createProcedure(date: Date? = nil) throws -> ModelsR4.Procedure {
        let procedure = ModelsR4.Procedure(
            id: "procedure-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.completed),
            subject: Reference(id: "patient-id".asFHIRStringPrimitive())
        )
        if let date = date {
            procedure.performed = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return procedure
    }

    static func createPatient(date: Date? = nil) throws -> ModelsR4.Patient {
        guard let utcTimeZone = TimeZone(abbreviation: "UTC") else {
            preconditionFailure("Failed to create UTC timezone")
        }

        let patient = ModelsR4.Patient(
            id: "patient-id".asFHIRStringPrimitive()
        )
        if let date = date {
            patient.birthDate = FHIRPrimitive(try FHIRDate(date: date, timeZone: utcTimeZone))
        }
        return patient
    }
    
    static func createProvenance(date: Date? = nil) throws -> ModelsR4.Provenance {
        ModelsR4.Provenance(
            agent: [
                ProvenanceAgent(
                    type: CodeableConcept(
                        coding: [Coding(code: "agent-type".asFHIRStringPrimitive())]
                    ),
                    who: Reference(id: "agent-id".asFHIRStringPrimitive())
                )
            ],
            id: "provenance-id".asFHIRStringPrimitive(),
            recorded: FHIRPrimitive(try Instant(date: date ?? FHIRResourceTests.testDate)),
            target: [
                Reference(id: "target-id".asFHIRStringPrimitive())
            ]
        )
    }
    
    static func createSupplyDelivery(date: Date? = nil) throws -> ModelsR4.SupplyDelivery {
        let supplyDelivery = ModelsR4.SupplyDelivery(
            id: "supply-delivery-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.completed)
        )
        if let date = date {
            supplyDelivery.occurrence = .dateTime(FHIRPrimitive(try DateTime(date: date)))
        }
        return supplyDelivery
    }
    
    static func createBundle() throws -> ModelsR4.Bundle {
        let bundle = Bundle(type: FHIRPrimitive(BundleType.transaction))
        let condition = try ModelsR4Mocks.createCondition()
        let observation = try ModelsR4Mocks.createObservation()

        bundle.entry = [
            BundleEntry(resource: .condition(condition)),
            BundleEntry(resource: .observation(observation))
        ]

        return bundle
    }

    static func createAttachment(
        id: String,
        title: String,
        contentType: String,
        content: String,
        creationDate: Date? = nil
    ) throws -> ModelsR4.Attachment {
        let attachment = ModelsR4.Attachment(
            contentType: FHIRPrimitive(stringLiteral: contentType),
            data: FHIRPrimitive(ModelsR4.Base64Binary(content)),
            id: id.asFHIRStringPrimitive(),
            title: FHIRPrimitive(ModelsR4.FHIRString(title))
        )

        if let creationDate {
            attachment.creation = FHIRPrimitive(try DateTime(date: creationDate))
        }

        return attachment
    }

    static func createDocumentReference(
        id: String = "document-reference-id",
        status: ModelsR4.DocumentReferenceStatus = .current,
        type: ModelsR4.CodeableConcept? = nil,
        attachments: [ModelsR4.Attachment] = [],
        date: Date? = nil
    ) throws -> ModelsR4.DocumentReference {
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
            ModelsR4.DocumentReferenceContent(attachment: attachment)
        }

        let documentReference = ModelsR4.DocumentReference(
            content: contentItems,
            status: FHIRPrimitive(status),
            type: documentType
        )

        documentReference.id = id.asFHIRStringPrimitive()

        if let date {
            documentReference.date = FHIRPrimitive<Instant>(try? Instant(date: date))
        }

        return documentReference
    }

    static func createTextAttachment(
        id: String = "text-attachment-id",
        title: String = "Text Attachment",
        creationDate: Date? = nil
    ) throws -> ModelsR4.Attachment {
        // This is a minimal base64-encoded text with the text "Welcome to SpeziFHIR"
        let textBase64 = "V2VsY29tZSB0byBTcGV6aUZISVI="

        return try createAttachment(
            id: id,
            title: title,
            contentType: "text/plain",
            content: textBase64,
            creationDate: creationDate
        )
    }

    static func createPDFAttachment(
        id: String = "pdf-attachment-id",
        title: String = "PDF Attachment",
        creationDate: Date? = nil
    ) throws -> ModelsR4.Attachment {
        // This is a minimal base64-encoded PDF with the text "PDF: Welcome to SpeziFHIR"
        // swiftlint:disable:next line_length
        let pdfBase64 = "JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA0IDAgUiA+PiA+PiAvQ29udGVudHMgNSAwIFIgPj4KZW5kb2JqCjQgMCBvYmoKPDwgL1R5cGUgL0ZvbnQgL1N1YnR5cGUgL1R5cGUxIC9CYXNlRm9udCAvSGVsdmV0aWNhID4+CmVuZG9iago1IDAgb2JqCjw8IC9MZW5ndGggNDQgPj4Kc3RyZWFtCkJUCi9GMSAxNiBUZgo1MCA3MDAgVGQKKFBERjogV2VsY29tZSB0byBTcGV6aUZISVIpIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmCjAwMDAwMDAwMDkgMDAwMDAgbgowMDAwMDAwMDU4IDAwMDAwIG4KMDAwMDAwMDExNSAwMDAwMCBuCjAwMDAwMDAyMjkgMDAwMDAgbgowMDAwMDAwMjk1IDAwMDAwIG4KdHJhaWxlcgo8PCAvU2l6ZSA2IC9Sb290IDEgMCBSID4+CnN0YXJ0eHJlZgozOTEKJSVFT0Y="

        return try createAttachment(
            id: id,
            title: title,
            contentType: "application/pdf",
            content: pdfBase64,
            creationDate: creationDate
        )
    }

    static func createMixedDocumentReference(
        id: String = "mixed-document-id",
        date: Date? = nil
    ) throws -> ModelsR4.DocumentReference {
        let textAttachment = try createAttachment(
            id: "text-attachment-id",
            title: "Text Component",
            contentType: "text/plain",
            content: "V2VsY29tZSB0byBTcGV6aUZISVI="
        )

        let pdfAttachment = try createPDFAttachment()

        return try createDocumentReference(
            id: id,
            attachments: [textAttachment, pdfAttachment],
            date: date
        )
    }
}
