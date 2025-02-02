//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2


enum ModelsDSTU2Mocks {
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

    static func createObservation(date: Date? = nil) throws -> ModelsDSTU2.Observation {
        let observation = ModelsDSTU2.Observation(
            code: CodeableConcept(
                coding: [
                    Coding(code: "code".asFHIRStringPrimitive())
                ]
            ),
            id: "observation-id".asFHIRStringPrimitive(),
            status: FHIRPrimitive(.final)
        )
        if let date = date {
            observation.issued = FHIRPrimitive(try Instant(date: date))
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
}
