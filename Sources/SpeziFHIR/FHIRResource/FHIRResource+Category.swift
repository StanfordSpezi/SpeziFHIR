//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import enum ModelsR4.ResourceProxy
import enum ModelsDSTU2.ResourceProxy


// swiftlint:disable file_length
// We disable the file length here to ensure that we cover all switch cases explicitly.
extension FHIRResource {
    /// Enum representing different categories of FHIR resources.
    /// This categorization helps in classifying FHIR resources into common healthcare scenarios and types.
    enum FHIRResourceCategory {
        /// Represents an observation-type resource (e.g., patient measurements, lab results).
        case observation
        /// Represents an encounter-type resource (e.g., patient visits, admissions).
        case encounter
        ///  Represents a condition-type resource (e.g., diagnoses, patient conditions).
        case condition
        /// Represents a diagnostic-type resource (e.g., radiology, pathology reports).
        case diagnostic
        /// Represents a procedure-type resource (e.g., surgical procedures, therapies).
        case procedure
        /// Represents an immunization-type resource (e.g., vaccine administrations).
        case immunization
        /// Represents an allergy or intolerance-type resource.
        case allergyIntolerance
        /// Represents a medication-type resource (e.g., prescriptions, medication administrations).
        case medication
        /// Represents other types of resources not covered by the above categories.
        case other
    }
    
    var storeKeyPath: KeyPath<FHIRStore, [FHIRResource]> {
        switch self.category {
        case .observation:
            \.observations
        case .encounter:
            \.encounters
        case .condition:
            \.conditions
        case .diagnostic:
            \.diagnostics
        case .procedure:
            \.procedures
        case .immunization:
            \.immunizations
        case .allergyIntolerance:
            \.allergyIntolerances
        case .medication:
            \.medications
        case .other:
            \.otherResources
        }
    }
    
        
    /// Category of the FHIR resource.
    ///
    /// Analyzes the type of the underlying resource and assigns it to an appropriate category.
    var category: FHIRResourceCategory {
        switch versionedResource {
        case let .r4(resource):
            switch ResourceProxy(with: resource) {
            case .account:
                return FHIRResourceCategory.other
            case .activityDefinition:
                return FHIRResourceCategory.other
            case .adverseEvent:
                return FHIRResourceCategory.other
            case .allergyIntolerance:
                return FHIRResourceCategory.allergyIntolerance
            case .appointment:
                return FHIRResourceCategory.other
            case .appointmentResponse:
                return FHIRResourceCategory.other
            case .auditEvent:
                return FHIRResourceCategory.other
            case .basic:
                return FHIRResourceCategory.other
            case .binary:
                return FHIRResourceCategory.other
            case .biologicallyDerivedProduct:
                return FHIRResourceCategory.other
            case .bodyStructure:
                return FHIRResourceCategory.other
            case .bundle:
                return FHIRResourceCategory.other
            case .capabilityStatement:
                return FHIRResourceCategory.other
            case .carePlan:
                return FHIRResourceCategory.other
            case .careTeam:
                return FHIRResourceCategory.other
            case .catalogEntry:
                return FHIRResourceCategory.other
            case .chargeItem:
                return FHIRResourceCategory.other
            case .chargeItemDefinition:
                return FHIRResourceCategory.other
            case .claim:
                return FHIRResourceCategory.other
            case .claimResponse:
                return FHIRResourceCategory.other
            case .clinicalImpression:
                return FHIRResourceCategory.other
            case .codeSystem:
                return FHIRResourceCategory.other
            case .communication:
                return FHIRResourceCategory.other
            case .communicationRequest:
                return FHIRResourceCategory.other
            case .compartmentDefinition:
                return FHIRResourceCategory.other
            case .composition:
                return FHIRResourceCategory.other
            case .conceptMap:
                return FHIRResourceCategory.other
            case .condition:
                return FHIRResourceCategory.condition
            case .consent:
                return FHIRResourceCategory.other
            case .contract:
                return FHIRResourceCategory.other
            case .coverage:
                return FHIRResourceCategory.other
            case .coverageEligibilityRequest:
                return FHIRResourceCategory.other
            case .coverageEligibilityResponse:
                return FHIRResourceCategory.other
            case .detectedIssue:
                return FHIRResourceCategory.other
            case .device:
                return FHIRResourceCategory.other
            case .deviceDefinition:
                return FHIRResourceCategory.other
            case .deviceMetric:
                return FHIRResourceCategory.other
            case .deviceRequest:
                return FHIRResourceCategory.other
            case .deviceUseStatement:
                return FHIRResourceCategory.other
            case .diagnosticReport:
                return FHIRResourceCategory.diagnostic
            case .documentManifest:
                return FHIRResourceCategory.other
            case .documentReference:
                return FHIRResourceCategory.other
            case .domainResource:
                return FHIRResourceCategory.other
            case .effectEvidenceSynthesis:
                return FHIRResourceCategory.other
            case .encounter:
                return FHIRResourceCategory.encounter
            case .endpoint:
                return FHIRResourceCategory.other
            case .enrollmentRequest:
                return FHIRResourceCategory.other
            case .enrollmentResponse:
                return FHIRResourceCategory.other
            case .episodeOfCare:
                return FHIRResourceCategory.other
            case .eventDefinition:
                return FHIRResourceCategory.other
            case .evidence:
                return FHIRResourceCategory.other
            case .evidenceVariable:
                return FHIRResourceCategory.other
            case .exampleScenario:
                return FHIRResourceCategory.other
            case .explanationOfBenefit:
                return FHIRResourceCategory.other
            case .familyMemberHistory:
                return FHIRResourceCategory.other
            case .flag:
                return FHIRResourceCategory.other
            case .goal:
                return FHIRResourceCategory.other
            case .graphDefinition:
                return FHIRResourceCategory.other
            case .group:
                return FHIRResourceCategory.other
            case .guidanceResponse:
                return FHIRResourceCategory.other
            case .healthcareService:
                return FHIRResourceCategory.other
            case .imagingStudy:
                return FHIRResourceCategory.other
            case .immunization:
                return FHIRResourceCategory.immunization
            case .immunizationEvaluation:
                return FHIRResourceCategory.immunization
            case .immunizationRecommendation:
                return FHIRResourceCategory.immunization
            case .implementationGuide:
                return FHIRResourceCategory.other
            case .insurancePlan:
                return FHIRResourceCategory.other
            case .invoice:
                return FHIRResourceCategory.other
            case .library:
                return FHIRResourceCategory.other
            case .linkage:
                return FHIRResourceCategory.other
            case .list:
                return FHIRResourceCategory.other
            case .location:
                return FHIRResourceCategory.other
            case .measure:
                return FHIRResourceCategory.other
            case .measureReport:
                return FHIRResourceCategory.other
            case .media:
                return FHIRResourceCategory.other
            case .medication:
                return FHIRResourceCategory.medication
            case .medicationAdministration:
                return FHIRResourceCategory.medication
            case .medicationDispense:
                return FHIRResourceCategory.medication
            case .medicationKnowledge:
                return FHIRResourceCategory.medication
            case .medicationRequest:
                return FHIRResourceCategory.medication
            case .medicationStatement:
                return FHIRResourceCategory.medication
            case .medicinalProduct:
                return FHIRResourceCategory.other
            case .medicinalProductAuthorization:
                return FHIRResourceCategory.other
            case .medicinalProductContraindication:
                return FHIRResourceCategory.other
            case .medicinalProductIndication:
                return FHIRResourceCategory.other
            case .medicinalProductIngredient:
                return FHIRResourceCategory.other
            case .medicinalProductInteraction:
                return FHIRResourceCategory.other
            case .medicinalProductManufactured:
                return FHIRResourceCategory.other
            case .medicinalProductPackaged:
                return FHIRResourceCategory.other
            case .medicinalProductPharmaceutical:
                return FHIRResourceCategory.other
            case .medicinalProductUndesirableEffect:
                return FHIRResourceCategory.other
            case .messageDefinition:
                return FHIRResourceCategory.other
            case .messageHeader:
                return FHIRResourceCategory.other
            case .molecularSequence:
                return FHIRResourceCategory.other
            case .namingSystem:
                return FHIRResourceCategory.other
            case .nutritionOrder:
                return FHIRResourceCategory.other
            case .observation:
                return FHIRResourceCategory.observation
            case .observationDefinition:
                return FHIRResourceCategory.observation
            case .operationDefinition:
                return FHIRResourceCategory.other
            case .operationOutcome:
                return FHIRResourceCategory.other
            case .organization:
                return FHIRResourceCategory.other
            case .organizationAffiliation:
                return FHIRResourceCategory.other
            case .parameters:
                return FHIRResourceCategory.other
            case .patient:
                return FHIRResourceCategory.other
            case .paymentNotice:
                return FHIRResourceCategory.other
            case .paymentReconciliation:
                return FHIRResourceCategory.other
            case .person:
                return FHIRResourceCategory.other
            case .planDefinition:
                return FHIRResourceCategory.other
            case .practitioner:
                return FHIRResourceCategory.other
            case .practitionerRole:
                return FHIRResourceCategory.other
            case .procedure:
                return FHIRResourceCategory.procedure
            case .provenance:
                return FHIRResourceCategory.other
            case .questionnaire:
                return FHIRResourceCategory.other
            case .questionnaireResponse:
                return FHIRResourceCategory.other
            case .relatedPerson:
                return FHIRResourceCategory.other
            case .requestGroup:
                return FHIRResourceCategory.other
            case .researchDefinition:
                return FHIRResourceCategory.other
            case .researchElementDefinition:
                return FHIRResourceCategory.other
            case .researchStudy:
                return FHIRResourceCategory.other
            case .researchSubject:
                return FHIRResourceCategory.other
            case .resource:
                return FHIRResourceCategory.other
            case .riskAssessment:
                return FHIRResourceCategory.other
            case .riskEvidenceSynthesis:
                return FHIRResourceCategory.other
            case .schedule:
                return FHIRResourceCategory.other
            case .searchParameter:
                return FHIRResourceCategory.other
            case .serviceRequest:
                return FHIRResourceCategory.other
            case .slot:
                return FHIRResourceCategory.other
            case .specimen:
                return FHIRResourceCategory.other
            case .specimenDefinition:
                return FHIRResourceCategory.other
            case .structureDefinition:
                return FHIRResourceCategory.other
            case .structureMap:
                return FHIRResourceCategory.other
            case .subscription:
                return FHIRResourceCategory.other
            case .substance:
                return FHIRResourceCategory.other
            case .substanceNucleicAcid:
                return FHIRResourceCategory.other
            case .substancePolymer:
                return FHIRResourceCategory.other
            case .substanceProtein:
                return FHIRResourceCategory.other
            case .substanceReferenceInformation:
                return FHIRResourceCategory.other
            case .substanceSourceMaterial:
                return FHIRResourceCategory.other
            case .substanceSpecification:
                return FHIRResourceCategory.other
            case .supplyDelivery:
                return FHIRResourceCategory.other
            case .supplyRequest:
                return FHIRResourceCategory.other
            case .task:
                return FHIRResourceCategory.other
            case .terminologyCapabilities:
                return FHIRResourceCategory.other
            case .testReport:
                return FHIRResourceCategory.other
            case .testScript:
                return FHIRResourceCategory.other
            case .valueSet:
                return FHIRResourceCategory.other
            case .verificationResult:
                return FHIRResourceCategory.other
            case .visionPrescription:
                return FHIRResourceCategory.other
            case .unrecognized:
                return FHIRResourceCategory.other
            }
        case let .dstu2(resource):
            switch ResourceProxy(with: resource) {
            case .account:
                return FHIRResourceCategory.other
            case .allergyIntolerance:
                return FHIRResourceCategory.allergyIntolerance
            case .appointment:
                return FHIRResourceCategory.other
            case .appointmentResponse:
                return FHIRResourceCategory.other
            case .auditEvent:
                return FHIRResourceCategory.other
            case .basic:
                return FHIRResourceCategory.other
            case .binary:
                return FHIRResourceCategory.other
            case .bodySite:
                return FHIRResourceCategory.other
            case .bundle:
                return FHIRResourceCategory.other
            case .carePlan:
                return FHIRResourceCategory.other
            case .claim:
                return FHIRResourceCategory.other
            case .claimResponse:
                return FHIRResourceCategory.other
            case .clinicalImpression:
                return FHIRResourceCategory.other
            case .communication:
                return FHIRResourceCategory.other
            case .communicationRequest:
                return FHIRResourceCategory.other
            case .composition:
                return FHIRResourceCategory.other
            case .conceptMap:
                return FHIRResourceCategory.other
            case .condition:
                return FHIRResourceCategory.condition
            case .conformance:
                return FHIRResourceCategory.other
            case .contract:
                return FHIRResourceCategory.other
            case .coverage:
                return FHIRResourceCategory.other
            case .dataElement:
                return FHIRResourceCategory.other
            case .detectedIssue:
                return FHIRResourceCategory.other
            case .device:
                return FHIRResourceCategory.other
            case .deviceComponent:
                return FHIRResourceCategory.other
            case .deviceMetric:
                return FHIRResourceCategory.other
            case .deviceUseRequest:
                return FHIRResourceCategory.other
            case .deviceUseStatement:
                return FHIRResourceCategory.other
            case .diagnosticOrder:
                return FHIRResourceCategory.diagnostic
            case .diagnosticReport:
                return FHIRResourceCategory.diagnostic
            case .documentManifest:
                return FHIRResourceCategory.other
            case .documentReference:
                return FHIRResourceCategory.other
            case .domainResource:
                return FHIRResourceCategory.other
            case .eligibilityRequest:
                return FHIRResourceCategory.other
            case .eligibilityResponse:
                return FHIRResourceCategory.other
            case .encounter:
                return FHIRResourceCategory.encounter
            case .enrollmentRequest:
                return FHIRResourceCategory.other
            case .enrollmentResponse:
                return FHIRResourceCategory.other
            case .episodeOfCare:
                return FHIRResourceCategory.other
            case .explanationOfBenefit:
                return FHIRResourceCategory.other
            case .familyMemberHistory:
                return FHIRResourceCategory.other
            case .flag:
                return FHIRResourceCategory.other
            case .goal:
                return FHIRResourceCategory.other
            case .group:
                return FHIRResourceCategory.other
            case .healthcareService:
                return FHIRResourceCategory.other
            case .imagingObjectSelection:
                return FHIRResourceCategory.other
            case .imagingStudy:
                return FHIRResourceCategory.other
            case .immunization:
                return FHIRResourceCategory.immunization
            case .immunizationRecommendation:
                return FHIRResourceCategory.immunization
            case .implementationGuide:
                return FHIRResourceCategory.other
            case .list:
                return FHIRResourceCategory.other
            case .location:
                return FHIRResourceCategory.other
            case .media:
                return FHIRResourceCategory.other
            case .medication:
                return FHIRResourceCategory.medication
            case .medicationAdministration:
                return FHIRResourceCategory.medication
            case .medicationDispense:
                return FHIRResourceCategory.medication
            case .medicationOrder:
                return FHIRResourceCategory.medication
            case .medicationStatement:
                return FHIRResourceCategory.medication
            case .messageHeader:
                return FHIRResourceCategory.other
            case .namingSystem:
                return FHIRResourceCategory.other
            case .nutritionOrder:
                return FHIRResourceCategory.other
            case .observation:
                return FHIRResourceCategory.observation
            case .operationDefinition:
                return FHIRResourceCategory.other
            case .operationOutcome:
                return FHIRResourceCategory.other
            case .order:
                return FHIRResourceCategory.other
            case .orderResponse:
                return FHIRResourceCategory.other
            case .organization:
                return FHIRResourceCategory.other
            case .parameters:
                return FHIRResourceCategory.other
            case .patient:
                return FHIRResourceCategory.other
            case .paymentNotice:
                return FHIRResourceCategory.other
            case .paymentReconciliation:
                return FHIRResourceCategory.other
            case .person:
                return FHIRResourceCategory.other
            case .practitioner:
                return FHIRResourceCategory.other
            case .procedure:
                return FHIRResourceCategory.procedure
            case .procedureRequest:
                return FHIRResourceCategory.procedure
            case .processRequest:
                return FHIRResourceCategory.other
            case .processResponse:
                return FHIRResourceCategory.other
            case .provenance:
                return FHIRResourceCategory.other
            case .questionnaire:
                return FHIRResourceCategory.other
            case .questionnaireResponse:
                return FHIRResourceCategory.other
            case .referralRequest:
                return FHIRResourceCategory.other
            case .relatedPerson:
                return FHIRResourceCategory.other
            case .resource:
                return FHIRResourceCategory.other
            case .riskAssessment:
                return FHIRResourceCategory.other
            case .schedule:
                return FHIRResourceCategory.other
            case .searchParameter:
                return FHIRResourceCategory.other
            case .slot:
                return FHIRResourceCategory.other
            case .specimen:
                return FHIRResourceCategory.other
            case .structureDefinition:
                return FHIRResourceCategory.other
            case .subscription:
                return FHIRResourceCategory.other
            case .substance:
                return FHIRResourceCategory.other
            case .supplyDelivery:
                return FHIRResourceCategory.other
            case .supplyRequest:
                return FHIRResourceCategory.other
            case .testScript:
                return FHIRResourceCategory.other
            case .valueSet:
                return FHIRResourceCategory.other
            case .visionPrescription:
                return FHIRResourceCategory.other
            case .unrecognized:
                return FHIRResourceCategory.other
            }
        }
    }
}
