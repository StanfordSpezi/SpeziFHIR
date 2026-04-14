//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

#if canImport(UIKit)

public import ModelsR4
public import enum UIKit.UIKeyboardType
public import enum UIKit.UITextAutocapitalizationType
public import struct UIKit.UITextContentType


extension QuestionnaireItem {
#if os(iOS) || os(visionOS)
    /// The item's preferred keyboard type.
    public var keyboardType: UIKeyboardType? {
        switch keyboardTypeRawValue {
        case nil:
            nil
        case "default":
            .default
        case "asciiCapable":
            .asciiCapable
        case "numbersAndPunctuation":
            .numbersAndPunctuation
        case "URL":
            .URL
        case "numberPad":
            .numberPad
        case "phonePad":
            .phonePad
        case "namePhonePad":
            .namePhonePad
        case "emailAddress":
            .emailAddress
        case "decimalPad":
            .decimalPad
        case "twitter":
            .twitter
        case "webSearch":
            .webSearch
        case "asciiCapableNumberPad":
            .asciiCapableNumberPad
        default:
            nil
        }
    }
#endif
    
    
#if os(iOS) || os(visionOS) || os(tvOS)
    /// The item's preferred autocapitalization behaviour.
    public var autocapitalizationType: UITextAutocapitalizationType? {
        switch autocapitalizationTypeRawValue {
        case nil:
            nil
        case "none":
            UITextAutocapitalizationType.none
        case "words":
            .words
        case "sentences":
            .sentences
        case "allCharacters":
            .allCharacters
        default:
            nil
        }
    }

    /// The item's preferred text content type.
    public var textContentType: UITextContentType? {
        switch textContentTypeRawValue {
        case nil:
            return nil
        case "URL":
            return .URL
        case "namePrefix":
            return .namePrefix
        case "name":
            return .name
        case "nameSuffix":
            return .nameSuffix
        case "givenName":
            return .givenName
        case "middleName":
            return .middleName
        case "familyName":
            return .familyName
        case "nickname":
            return .nickname
        case "organizationName":
            return .organizationName
        case "jobTitle":
            return .jobTitle
        case "location":
            return .location
        case "fullStreetAddress":
            return .fullStreetAddress
        case "streetAddressLine1":
            return .streetAddressLine1
        case "streetAddressLine2":
            return .streetAddressLine2
        case "addressCity":
            return .addressCity
        case "addressCityAndState":
            return .addressCityAndState
        case "addressState":
            return .addressState
        case "postalCode":
            return .postalCode
        case "sublocality":
            return .sublocality
        case "countryName":
            return .countryName
        case "username":
            return .username
        case "password":
            return .password
        case "newPassword":
            return .newPassword
        case "oneTimeCode":
            return .oneTimeCode
        case "emailAddress":
            return .emailAddress
        case "telephoneNumber":
            return .telephoneNumber
        case "creditCardNumber":
            return .creditCardNumber
        case "dateTime":
            return .dateTime
        case "flightNumber":
            return .flightNumber
        case "shipmentTrackingNumber":
            return .shipmentTrackingNumber
        case .some(let textContentTypeRawValue):
            if #available(iOS 17, visionOS 1, tvOS 17, *) {
                switch textContentTypeRawValue {
                case "creditCardExpiration":
                    return .creditCardExpiration
                case "creditCardExpirationMonth":
                    return .creditCardExpirationMonth
                case "creditCardExpirationYear":
                    return .creditCardExpirationYear
                case "creditCardSecurityCode":
                    return .creditCardSecurityCode
                case "creditCardType":
                    return .creditCardType
                case "creditCardName":
                    return .creditCardName
                case "creditCardGivenName":
                    return .creditCardGivenName
                case "creditCardMiddleName":
                    return .creditCardMiddleName
                case "creditCardFamilyName":
                    return .creditCardFamilyName
                case "birthdate":
                    return .birthdate
                default:
                    break
                }
            }
            return nil
        }
    }
#endif
}

#endif
