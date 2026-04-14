//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

private import FHIRPathParser
public import Foundation
public import ModelsR4
private import OSLog


extension QuestionnaireItem {
    /// Supported FHIR extensions for QuestionnaireItems
    private enum SupportedExtensions {
        static let itemControl = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
        static let questionnaireUnit = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
        static let regex = "http://hl7.org/fhir/StructureDefinition/regex"
        static let sliderStepValue = "http://hl7.org/fhir/StructureDefinition/questionnaire-sliderStepValue"
        static let maxDecimalPlaces = "http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces"
        static let minValue = "http://hl7.org/fhir/StructureDefinition/minValue"
        static let maxValue = "http://hl7.org/fhir/StructureDefinition/maxValue"
        static let hidden = "http://hl7.org/fhir/StructureDefinition/questionnaire-hidden"
        static let entryFormat = "http://hl7.org/fhir/StructureDefinition/entryFormat"
        
        static let validationMessageLegacy = "http://biodesign.stanford.edu/fhir/StructureDefinition/validationtext"
        static let validationMessage = "http://bdh.stanford.edu/fhir/StructureDefinition/validationtext"
        static let keyboardType = "http://bdh.stanford.edu/fhir/StructureDefinition/ios-keyboardtype"
        
        static let textContentType = "http://bdh.stanford.edu/fhir/StructureDefinition/ios-textcontenttype"
        static let autocapitalizationType = "http://bdh.stanford.edu/fhir/StructureDefinition/ios-autocapitalizationType"
        
        static let dateMaxValue = "http://ehelse.no/fhir/StructureDefinition/sdf-maxvalue"
        static let dateMinValue = "http://ehelse.no/fhir/StructureDefinition/sdf-minvalue"
    }

    private static let logger = Logger(subsystem: "edu.stanford.spezi.researchkit-on-fhir", category: "FHIRExtensions")

    /// Is the question hidden
    /// - Returns: A boolean representing whether the question should be shown to the user
    public var hidden: Bool {
        guard let hiddenExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.hidden),
              case let .boolean(booleanValue) = hiddenExtension.value,
              let isHidden = booleanValue.value?.bool as? Bool else {
            return false
        }
        return isHidden
    }

    /// Defines the control type for the answer for a question
    /// - Returns: A code representing the control type (i.e. slider)
    public var itemControl: String? {
        guard let itemControlExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.itemControl),
              case let .codeableConcept(concept) = itemControlExtension.value,
              let itemControlCode = concept.coding?.first?.code?.value?.string else {
            return nil
        }
        return itemControlCode
    }
    
    /// The minimum value for a numerical answer.
    /// - Returns: An optional `NSNumber` containing the minimum value allowed.
    public var minValue: NSNumber? {
        numericMinMaxValue(url: SupportedExtensions.minValue)
    }
    
    /// The maximum value for a numerical answer.
    /// - Returns: An optional `NSNumber` containing the maximum value allowed.
    public var maxValue: NSNumber? {
        numericMinMaxValue(url: SupportedExtensions.maxValue)
    }
    
    /// The minimum value for a date answer.
    /// - Returns: An optional `DateComponents` containing the minimum date allowed.
    public var minDateValue: DateComponents? {
        dateMinMaxValue(urls: [SupportedExtensions.minValue, SupportedExtensions.dateMinValue])
    }
    
    /// The maximum value for a date answer.
    /// - Returns: An optional `DateComponents` containing the maximum date allowed.
    public var maxDateValue: DateComponents? {
        dateMinMaxValue(urls: [SupportedExtensions.maxValue, SupportedExtensions.dateMaxValue])
    }
    
    /// The maximum number of decimal places for a decimal answer.
    /// - Returns: An optional `NSNumber` representing the maximum number of digits to the right of the decimal place.
    public var maximumDecimalPlaces: NSNumber? {
        guard let maxDecimalPlacesExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.maxDecimalPlaces),
              case let .integer(integerValue) = maxDecimalPlacesExtension.value,
              let maxDecimalPlaces = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: maxDecimalPlaces)
    }

    /// The offset between numbers on a numerical slider
    /// - Returns: An optional `NSNumber` representing the size of each discrete offset on the scale.
    public var sliderStepValue: NSNumber? {
        guard let sliderStepValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.sliderStepValue),
              case let .integer(integerValue) = sliderStepValueExtension.value,
              let sliderStepValue = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: sliderStepValue)
    }
    
    /// The unit of a quantity answer type.
    /// - Returns: An optional `String` containing the unit (i.e. cm) if it was provided.
    public var unit: String? {
        guard let unitExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.questionnaireUnit),
              case let .coding(coding) = unitExtension.value else {
            return nil
        }
        return coding.code?.value?.string
    }
    
    /// The regular expression specified for validating a text input in a question.
    /// - Returns: An optional `String` containing the regular expression, if it exists.
    public var validationRegularExpression: NSRegularExpression? {
        if let pattern = extensions(for: SupportedExtensions.regex).first?.value?.stringValue?.value?.string {
            try? NSRegularExpression(pattern: pattern)
        } else {
            nil
        }
    }
    
    /// The validation message for a question.
    /// - Returns: An optional `String` containing the validation message, if it exists.
    public var validationMessage: String? {
        let ext = extensions(for: SupportedExtensions.validationMessage).first ?? extensions(for: SupportedExtensions.validationMessageLegacy).first
        return ext?.value?.stringValue?.value?.string
    }

    /// The placeholder text associated with the questionaire item.
    public var placeholderText: String? {
        extensions(for: SupportedExtensions.entryFormat).first?.value?.stringValue?.value?.string
    }
    
    /// The item's preferred keyboard type.
    public var keyboardTypeRawValue: String? {
        extensions(for: SupportedExtensions.keyboardType).first?.value?.stringValue?.value?.string
    }
    
    /// The item's preferred autocapitalization behaviour.
    public var autocapitalizationTypeRawValue: String? {
        extensions(for: SupportedExtensions.autocapitalizationType).first?.value?.stringValue?.value?.string
    }

    /// The item's preferred text content type.
    public var textContentTypeRawValue: String? {
        extensions(for: SupportedExtensions.textContentType).first?.value?.stringValue?.value?.string
    }

    
    /// Checks this QuestionnaireItem for an extension matching the given URL and then return it if it exists.
    /// - Parameters:
    ///   - url: A `String` identifying the extension.
    /// - Returns: an optional Extension if it was found.
    private func getExtensionInQuestionnaireItem(url: String) -> Extension? {
        self.`extension`?.first(where: { $0.url.value?.url.absoluteString == url })
    }
    
    private func numericMinMaxValue(url: String) -> NSNumber? {
        switch getExtensionInQuestionnaireItem(url: url)?.value {
        case .integer(let integer):
            (integer.value?.integer).map { NSNumber(value: $0) }
        case .decimal(let decimal):
            (decimal.value?.decimal).map { NSDecimalNumber(decimal: $0) }
        case .quantity(let quantity):
            // Note: this operates on the assumption that the unit used by the min/maxValue quantity is using the same unit as the question itself.
            (quantity.value?.value?.decimal).map { NSDecimalNumber(decimal: $0) }
        default:
            nil
        }
    }
    
    private func dateMinMaxValue(urls: [String]) -> DateComponents? { // swiftlint:disable:this cyclomatic_complexity
        for url in urls {
            guard let ext = getExtensionInQuestionnaireItem(url: url) else {
                continue
            }
            switch ext.value {
            case .date(let value):
                guard let value = value.value else {
                    continue
                }
                return value.dateComponents()
            case .time(let value):
                guard let value = value.value else {
                    continue
                }
                return value.dateComponents()
            case .dateTime(let value):
                guard let value = value.value else {
                    continue
                }
                return value.dateComponents()
            case .string(let value):
                guard let value = value.value?.string else {
                    continue
                }
                if let value = try? FHIRPathExpression.evaluate(expression: value, as: DateComponents.self) {
                    return value
                } else {
                    continue
                }
            default:
                continue
            }
        }
        return nil
    }
}
