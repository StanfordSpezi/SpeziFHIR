//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import Foundation
public import ModelsR4


extension FHIRDate {
    /// Creates a `DateComponents` instance with the `year`, `month`, and `day` components populated.
    ///
    /// - parameter fallback: The value that should be used for the `month` and `day` components, if the `FHIRDate` is missing the component.
    @inlinable
    public func dateComponents(missingComponentFallback fallback: Int? = 1) -> DateComponents {
        DateComponents(
            year: self.year,
            month: self.month.map(numericCast) ?? fallback,
            day: self.day.map(numericCast) ?? fallback
        )
    }
}


extension FHIRTime {
    /// Creates a `DateComponents` instance with the `hour`, `minute`, and `second` components populated.
    ///
    /// - Note: The `FHIRTime`'s `second` value will be rounded if necessary.
    @inlinable
    public func dateComponents() -> DateComponents {
        DateComponents(
            hour: Int(self.hour),
            minute: Int(self.minute),
            second: self.second.intValue
        )
    }
}


extension DateTime {
    /// Creates a `DateComponents` instance with the `timeZone`, `year`, `month`, `day`, `hour`, `minute`, and `second` components populated.
    ///
    /// - parameter dateFallback: The value that should be used for the `month` and `day` components, if the `FHIRDate` is missing the component.
    @inlinable
    public func dateComponents(missingDateComponentFallback dateFallback: Int? = 1) -> DateComponents {
        var components = self.date.dateComponents(missingComponentFallback: dateFallback)
        if let timeComps = self.time?.dateComponents() {
            components.hour = timeComps.hour
            components.minute = timeComps.minute
            components.second = timeComps.second
        }
        if let originalTimeZoneString {
            components.timeZone = TimeZone(identifier: originalTimeZoneString)
        }
        return components
    }
}


extension Questionnaire {
    /// All items in the questionnaire, flattened.
    /// - Note: individual items in the returned array may still contain nested items;
    ///     the purpose of this property is to easily be able to access all items in the questionnaire, without having to explicitly take any nesting into account.
    var flattenedItems: [QuestionnaireItem] {
        flattenedItems()
    }
    
    /// All directly answerable items in the questionnaire, flattened.
    /// - Note: individual items in the returned array may still contain nested items;
    ///     the purpose of this property is to easily be able to access all questions in the questionnaire, without having to explicitly take any nesting into account.
    var flattenedQuestions: [QuestionnaireItem] {
        flattenedItems { $0.type.value?.isDirectlyAnswerableQuestion == true }
    }
    
    /// Flattens all `QuestionnaireItem`s in the questionnaire into an array.
    /// - parameter predicate: A predicate for filtering which items should be included. By default, all items are included.
    ///     Note that excluding an item via the predicate will only exclude it from being added to the returned array.
    ///     Children of excluded items will still be considered and may be included in the returned value, if the predicate returns true.
    private func flattenedItems(
        filter predicate: (QuestionnaireItem) -> Bool = { _ in true }
    ) -> [QuestionnaireItem] {
        var retval: [QuestionnaireItem] = []
        func imp(_ item: QuestionnaireItem) {
            if predicate(item) {
                retval.append(item)
            }
            item.item?.forEach(imp)
        }
        item?.forEach(imp)
        return retval
    }
}

extension QuestionnaireItemType {
    /// Whether the item type refers to a directly answerable question.
    var isDirectlyAnswerableQuestion: Bool {
        switch self {
        case .group:
            false
        case .display:
            false
        case .question, .boolean, .decimal, .integer, .date, .dateTime, .time, .string, .text, .url,
                .choice, .openChoice, .attachment, .reference, .quantity:
            true
        }
    }
}
