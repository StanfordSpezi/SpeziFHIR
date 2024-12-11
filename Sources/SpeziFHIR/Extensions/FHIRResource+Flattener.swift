//
//  FHIRResource+Flattener.swift
//  SpeziFHIR
//
//  Created by Leon Nissen on 11/9/24.
//

import Foundation
import ModelsDSTU2
import ModelsR4


extension FHIRResource {
    /// A computed property that generates an extended description of a FHIR resource.
    /// - Returns: A brief description of the resource, or an empty string if no description is available.
    public var resourceDescription: String {
        switch versionedResource {
        case let .r4(resource):
            switch resource {
            case let patient as ModelsR4.Patient:
                return constructPatientDescription(patient)
            case let observation as ModelsR4.Observation:
                return constructeObservationDescription(observation)
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    /// A computed property that generates a short description of a FHIR resource.
    /// - Returns: A brief description of the resource, or an empty string if no description is available.
    public var shortResourceDescription: String {
        switch versionedResource {
        case let .r4(resource):
            switch resource {
            case let patient as ModelsR4.Patient:
                return constructShortPatientDescription(patient)
            case let observation as ModelsR4.Observation:
                return constructeShortObservationDescription(observation)
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    
    private func constructShortPatientDescription(_ patient: ModelsR4.Patient) -> String {
        """
        Patient name is \(patientNameToString(patient)), gender is \(patientGenderToString(patient)). Born: \(patientBirthDateToString(patient)). Main communication language is \(patientLanguageToString(patient)).
        """
    }
    
    private func constructeShortObservationDescription(_ observation: ModelsR4.Observation) -> String {
        """
        This \(splitCamel(resourceType)) is \(observationCodeToString(observation)), value: \(observationValueToString(observation)) at \(observationEffectiveDateTimeToString(observation)).
        """
    }
    
    
    private func constructPatientDescription(_ patient: ModelsR4.Patient) -> String {
        """
        The name for this patient is \(patientNameToString(patient)).
        The gender for this patient is \(patientGenderToString(patient)).
        The birth date for this patient is \(patientBirthDateToString(patient)).
        The communication language for this patient is \(patientLanguageToString(patient)).
        """
    }

    private func constructeObservationDescription(_ observation: ModelsR4.Observation) -> String {
        """
        The type of information in this entry is \(splitCamel(resourceType)).
        The status for this \(splitCamel(resourceType)) is \(observationStatusToString(observation)).
        The category of this obervarion is \(observationCategoryToString(observation)).
        The code for this observation is \(observationCodeToString(observation)).
        The observation was effectove date time on \(observationEffectiveDateTimeToString(observation)).
        The value \(observationTypeToString(observation)) for this observation is \(observationValueToString(observation)).
        """
    }
    
    private func patientNameToString(_ patient: ModelsR4.Patient) -> String {
        guard let name = patient.name?.first?.text else {
            return "N/A"
        }
        return name.value?.string ?? "N/A"
    }
    
    private func patientGenderToString(_ patient: ModelsR4.Patient) -> String {
        guard let gender = patient.gender?.value?.rawValue else {
            return "N/A"
        }
        return gender
    }
    
    private func patientBirthDateToString(_ patient: ModelsR4.Patient) -> String {
        guard let birthDate = patient.birthDate?.valueDescription else {
            return "N/A"
        }
        
        if let brithDate = try? patient.birthDate?.value?.asNSDate(),
           let years = Calendar.current.dateComponents([.year], from: brithDate, to: .now).year {
            return birthDate + " (\(years) years old)"
        }
        
        return birthDate
    }
    
    private func patientLanguageToString(_ patient: ModelsR4.Patient) -> String {
        guard let language = patient.communication?.first?.language.coding?.first?.code else {
            return "N/A"
        }
        return language.valueDescription
    }
    
    private func observationStatusToString(_ observation: ModelsR4.Observation) -> String {
        guard let status = observation.status.value?.rawValue else {
            return "N/A"
        }
        return status
    }
    
    private func observationCategoryToString(_ observation: ModelsR4.Observation) -> String {
        guard let category = observation.category else {
            return "N/A"
        }
        let joinedCoding = category.compactMap(\.coding).joined()
        let joinedCodingDisplay = joinedCoding.compactMap { $0.display?.value?.string }.joined(separator: ", ")
        return joinedCodingDisplay
    }
    
    private func observationCodeToString(_ observation: ModelsR4.Observation) -> String {
        guard let coding = observation.code.coding else {
            return "N/A"
        }
        return coding.compactMap { $0.display?.value?.string }.joined(separator: ", ")
    }
    
    private func observationEffectiveDateTimeToString(_ observation: ModelsR4.Observation) -> String {
        guard let effectiveDateTime = observation.effective else {
            return "N/A"
        }
        switch effectiveDateTime {
        case let .dateTime(value):
            return value.valueDescription
        case let .instant(value):
            return value.valueDescription
        case let .period(value):
            return value.valueDescription
        case let .timing(value):
            return value.valueDescription
        }
    }
    
    private func observationTypeToString(_ observation: ModelsR4.Observation) -> String {
        guard let value = observation.value else {
            return "N/A"
        }
        return value.typeName
    }
    
    private func observationValueToString(_ observation: ModelsR4.Observation) -> String {
        switch observation.value {
        case let .boolean(boolean):
            return boolean.valueDescription
        case let .dateTime(dateTime):
            return dateTime.valueDescription
        case let .string(string):
            return string.valueDescription
        case let .quantity(quantity):
            return quantity.valueDescription
        case let .integer(integer):
            return integer.valueDesciption
        case let .period(period):
            return period.valueDescription
        case let .time(time):
            return time.valueDescription
        case let .range(range):
            return range.valueDescription
        default:
            return ""
        }
    }
    
    fileprivate func splitCamel(_ text: String) -> String {
        var newText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        newText = newText.replacingOccurrences(
            of: #"([a-z])([A-Z])"#,
            with: "$1 $2",
            options: .regularExpression
        )
        
        newText = newText.replacingOccurrences(
            of: #"([A-Z]+)([A-Z][a-z])"#,
            with: "$1 $2",
            options: .regularExpression
        )
        
        return newText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


extension ModelsR4.Observation.ValueX {
    var typeName: String {
        switch self {
        case .boolean: "boolean"
        case .codeableConcept: "codeable concept"
        case .dateTime: "date time"
        case .integer: "number"
        case .period: "period"
        case .quantity: "quantity"
        case .range: "range"
        case .ratio: "ratio"
        case .sampledData: "sampled data"
        case .string: "string"
        case .time: "time"
        }
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRBool {
    var valueDescription: String {
        guard let value = self.value?.bool else {
            return "N/A"
        }
        return "\(value)"
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRDate {
    var valueDescription: String {
        guard let value = try? self.value?.asNSDate() else {
            return "N/A"
        }
        return "\(value.formatted(.dateTime))"
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRDecimal {
    var valueDescription: String {
        guard let value = self.value?.decimal else {
            return "N/A"
        }
        return NSDecimalNumber(decimal: value).stringValue
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRString {
    var valueDescription: String {
        guard let value = self.value?.string else {
            return "N/A"
        }
        return value
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRInteger {
    var valueDesciption: String {
        guard let value = self.value?.integer else {
            return "N/A"
        }
        return String(value)
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.DateTime {
    var valueDescription: String {
        guard let value = try? self.value?.asNSDate() else {
            return "N/A"
        }
        return "\(value.formatted(.dateTime))"
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.FHIRTime {
    var valueDescription: String {
        guard let value = self.value else {
            return "N/A"
        }
        return value.description
    }
}

extension ModelsR4.FHIRPrimitive where PrimitiveType == ModelsR4.Instant {
    var valueDescription: String {
        guard let value = try? self.value?.asNSDate() else {
            return "N/A"
        }
        return "\(value.formatted(.dateTime))"
    }
}

extension ModelsR4.Period {
    var valueDescription: String {
        guard let valueStart = try? self.start?.value?.asNSDate(),
              let valueEnd = try? self.end?.value?.asNSDate() else {
            return "N/A"
        }
        return "\(valueStart.formatted(.dateTime)) - \(valueEnd.formatted(.dateTime))"
    }
}

extension ModelsR4.Range {
    var valueDescription: String {
        guard let valueLow = self.low?.value?.value,
              let valueHigh = self.high?.value?.value else {
            return "N/A"
        }
        return "\(valueLow) - \(valueHigh)"
    }
}

extension ModelsR4.Quantity {
    var valueDescription: String {
        guard let value = self.value?.value?.decimal,
              let unit = self.unit?.value else {
            return "N/A"
        }
        return "\(value) \(unit)"
    }
}

extension ModelsR4.Timing {
    var valueDescription: String {
        guard let value = self.event?.compactMap({ $0.valueDescription }).joined() else {
            return "N/A"
        }
        return value
    }
}
