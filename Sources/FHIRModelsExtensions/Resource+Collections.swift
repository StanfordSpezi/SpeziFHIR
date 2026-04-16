//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable discouraged_optional_collection

public import ModelsR4

extension Observation {
    /// Appends an `Identifier` to the `Observation`
    @inlinable
    public mutating func appendIdentifier(_ identifier: Identifier) {
        appendElement(identifier, to: \.identifier)
    }
    
    /// Appends multiple `Identifier`s to the `Observation`
    @inlinable
    public mutating func appendIdentifiers(_ identifiers: some Collection<Identifier>) {
        appendElements(identifiers, to: \.identifier)
    }
    
    /// Appends a `CodeableConcept` to the `Observation`
    @inlinable
    public mutating func appendCategory(_ category: CodeableConcept) {
        appendElement(category, to: \.category)
    }
    
    /// Appends multiple `CodeableConcept`s to the `Observation`
    @inlinable
    public mutating func appendCategories(_ categories: some Collection<CodeableConcept>) {
        appendElements(categories, to: \.category)
    }
    
    /// Appends a `Coding` to the `Observation`
    @inlinable
    public mutating func appendCoding(_ coding: Coding) {
        appendElement(coding, to: \.code.coding)
    }
    
    /// Appends multiple `Coding`s to the `Observation`
    @inlinable
    public mutating func appendCodings(_ codings: some Collection<Coding>) {
        appendElements(codings, to: \.code.coding)
    }
    
    /// Appends an `ObservationComponent` to the `Observation`
    @inlinable
    public mutating func appendComponent(_ component: ObservationComponent) {
        appendElement(component, to: \.component)
    }
    
    /// Appends multiple `ObservationComponent`s to the `Observation`
    @inlinable
    public mutating func appendComponents(_ components: some Collection<ObservationComponent>) {
        appendElements(components, to: \.component)
    }
}


extension ModelsR4._FHIRTypeWithExtensions {
    /// Retrieves all FHIR Extensions for the specified url.
    @inlinable
    public func extensions(for url: FHIRPrimitive<FHIRURI>) -> [Extension] {
        `extension`.map { $0.filter { $0.url == url } } ?? []
    }
}


extension ModelsR4._FHIRTypeWithExtensions {
    /// Appends an `Extension` to the `DomainResource`
    @inlinable
    public mutating func appendExtension(_ extension: Extension, replaceAllExistingWithSameUrl: Bool) {
        appendExtensions(CollectionOfOne(`extension`), replaceAllExistingWithSameUrl: replaceAllExistingWithSameUrl)
    }
    
    /// Appends multiple `Extension`s to the `DomainResource`
    @inlinable
    public mutating func appendExtensions(_ extensions: some Collection<Extension>, replaceAllExistingWithSameUrl: Bool) {
        if replaceAllExistingWithSameUrl {
            for element in extensions {
                removeAllExtensions(withUrl: element.url)
            }
        }
        appendElements(extensions, to: \.extension)
    }
    
    /// Removes the first extension element that matches the specified url.
    ///
    /// - returns: the removed extension element, if any.
    @inlinable
    @discardableResult
    public mutating func removeFirstExtension(withUrl url: FHIRPrimitive<FHIRURI>) -> Extension? {
        removeFirstElement(of: \.extension) { $0.url == url }
    }
    
    /// Removes all extension elements that matches the specified url.
    ///
    /// - returns: the removed extension elements, if any.
    @inlinable
    @discardableResult
    public mutating func removeAllExtensions(withUrl url: FHIRPrimitive<FHIRURI>) -> [Extension]? {
        removeAllElements(of: \.extension) { $0.url == url }
    }
}
