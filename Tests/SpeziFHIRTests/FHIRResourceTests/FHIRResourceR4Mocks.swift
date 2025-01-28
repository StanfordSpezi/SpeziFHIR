//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension FHIRResourceTests {
    enum ModelsR4Mocks { // swiftlint:disable:this type_body_length
        static func createAllergyIntolerance() -> ModelsR4.AllergyIntolerance {
            ModelsR4.AllergyIntolerance(
                id: "allergy-intolerance-id".asFHIRStringPrimitive(),
                patient: Reference(id: "patient-id".asFHIRStringPrimitive())
            )
        }

        static func createCarePlan(date: Date) throws -> ModelsR4.CarePlan {
            let period = ModelsR4.Period()
            period.start = try FHIRPrimitive(DateTime(date: date))
            
            return ModelsR4.CarePlan(
                id: "care-plan-id".asFHIRStringPrimitive(),
                intent: FHIRPrimitive(.plan),
                period: period,
                status: FHIRPrimitive(.active),
                subject: Reference(id: "patient-id".asFHIRStringPrimitive())
            )
        }
        
        static func createCareTeam(date: Date) throws -> ModelsR4.CareTeam {
            let period = ModelsR4.Period()
            period.start = try FHIRPrimitive(DateTime(date: date))
            
            return ModelsR4.CareTeam(
                id: "care-team-id".asFHIRStringPrimitive(),
                period: period,
                status: FHIRPrimitive(.active)
            )
        }
        
        static func createClaim(date: Date) throws -> ModelsR4.Claim {
            let period = ModelsR4.Period()
            period.end = try FHIRPrimitive(DateTime(date: date))
            
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
        
        static func createCondition(date: Date) throws -> ModelsR4.Condition {
            ModelsR4.Condition(
                id: "condition-id".asFHIRStringPrimitive(),
                onset: .dateTime(FHIRPrimitive(try DateTime(date: date))),
                subject: Reference(id: "patient-id".asFHIRStringPrimitive())
            )
        }
        
        static func createDevice(date: Date) throws -> ModelsR4.Device {
            ModelsR4.Device(
                id: "device-id".asFHIRStringPrimitive(),
                manufactureDate: FHIRPrimitive(try DateTime(date: date))
            )
        }
        
        static func createDiagnosticReport(date: Date) throws -> ModelsR4.DiagnosticReport {
            ModelsR4.DiagnosticReport(
                code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
                effective: .dateTime(FHIRPrimitive(try DateTime(date: date))),
                id: "diagnostic-report-id".asFHIRStringPrimitive(),
                status: FHIRPrimitive(.final)
            )
        }
        
        static func createDocumentReference(date: Date) throws -> ModelsR4.DocumentReference {
            let content = ModelsR4.DocumentReferenceContent(
                attachment: Attachment(
                    contentType: "text/plain".asFHIRStringPrimitive()
                )
            )
            
            return ModelsR4.DocumentReference(
                content: [content],
                date: FHIRPrimitive(try Instant(date: date)),
                id: "document-reference-id".asFHIRStringPrimitive(),
                status: FHIRPrimitive(.current)
            )
        }
        
        static func createEncounter(date: Date) throws -> ModelsR4.Encounter {
            let period = ModelsR4.Period()
            period.end = try FHIRPrimitive(DateTime(date: date))
            
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
        
        static func createExplanationOfBenefit(date: Date) throws -> ModelsR4.ExplanationOfBenefit {
            let period = ModelsR4.Period()
            period.end = try FHIRPrimitive(DateTime(date: date))
            
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
        
        static func createImmunization(date: Date) throws -> ModelsR4.Immunization {
            ModelsR4.Immunization(
                id: "immunization-id".asFHIRStringPrimitive(),
                occurrence: .dateTime(FHIRPrimitive(try DateTime(date: date))),
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
        
        static func createImmunizationRecommendation(date: Date) throws -> ModelsR4.ImmunizationRecommendation {
            ModelsR4.ImmunizationRecommendation(
                date: FHIRPrimitive(try DateTime(date: date)),
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
        
        static func createMedicationRequest(date: Date) throws -> ModelsR4.MedicationRequest {
            ModelsR4.MedicationRequest(
                authoredOn: FHIRPrimitive(try DateTime(date: date)),
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
        }
        
        static func createMedicationAdministration(date: Date) throws -> ModelsR4.MedicationAdministration {
            ModelsR4.MedicationAdministration(
                effective: .dateTime(FHIRPrimitive(try DateTime(date: date))),
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
        
        static func createObservation(date: Date) throws -> ModelsR4.Observation {
            ModelsR4.Observation(
                code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
                id: "observation-id".asFHIRStringPrimitive(),
                issued: FHIRPrimitive(try Instant(date: date)),
                status: FHIRPrimitive(.final)
            )
        }
        
        static func createObservationDefinition() -> ModelsR4.ObservationDefinition {
            ModelsR4.ObservationDefinition(
                code: CodeableConcept(coding: [Coding(code: "code".asFHIRStringPrimitive())]),
                id: "observation-definition-id".asFHIRStringPrimitive()
            )
        }
        
        static func createProcedure(date: Date) throws -> ModelsR4.Procedure {
            ModelsR4.Procedure(
                id: "procedure-id".asFHIRStringPrimitive(),
                performed: .dateTime(FHIRPrimitive(try DateTime(date: date))),
                status: FHIRPrimitive(.completed),
                subject: Reference(id: "patient-id".asFHIRStringPrimitive())
            )
        }

        static func createPatient(date: Date) throws -> ModelsR4.Patient {
            guard let utcTimeZone = TimeZone(abbreviation: "UTC") else {
                preconditionFailure("Failed to create UTC timezone")
            }
                
            return ModelsR4.Patient(
                birthDate: FHIRPrimitive(try FHIRDate(date: date, timeZone: utcTimeZone)),
                id: "patient-id".asFHIRStringPrimitive()
            )
        }
        
        static func createProvenance(date: Date) throws -> ModelsR4.Provenance {
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
                recorded: FHIRPrimitive(try Instant(date: date)),
                target: [
                    Reference(id: "target-id".asFHIRStringPrimitive())
                ]
            )
        }
        
        static func createSupplyDelivery(date: Date) throws -> ModelsR4.SupplyDelivery {
            ModelsR4.SupplyDelivery(
                id: "supply-delivery-id".asFHIRStringPrimitive(),
                occurrence: .dateTime(FHIRPrimitive(try DateTime(date: date))),
                status: FHIRPrimitive(.completed)
            )
        }
    }
}
