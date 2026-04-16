//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import ModelsR4


extension Observation {
    /// Appends an `Identifier` to the `Observation`
    @inlinable
    public mutating func appendIdentifier(_ identifier: Identifier) {
        appendElement(identifier, to: \.identifier)
    }
    
    /// Appends multiple `Identifier`s to the `Observation`
    @inlinable
    public mutating func appendIdentifiers(_ identifiers: some Sequence<Identifier>) {
        appendElements(identifiers, to: \.identifier)
    }
    
    /// Appends a `CodeableConcept` to the `Observation`
    @inlinable
    public mutating func appendCategory(_ category: CodeableConcept) {
        appendElement(category, to: \.category)
    }
    
    /// Appends multiple `CodeableConcept`s to the `Observation`
    @inlinable
    public mutating func appendCategories(_ categories: some Sequence<CodeableConcept>) {
        appendElements(categories, to: \.category)
    }
    
    /// Appends a `Coding` to the `Observation`
    @inlinable
    public mutating func appendCoding(_ coding: Coding) {
        appendElement(coding, to: \.code.coding)
    }
    
    /// Appends multiple `Coding`s to the `Observation`
    @inlinable
    public mutating func appendCodings(_ codings: some Sequence<Coding>) {
        appendElements(codings, to: \.code.coding)
    }
    
    /// Appends an `ObservationComponent` to the `Observation`
    @inlinable
    public mutating func appendComponent(_ component: ObservationComponent) {
        appendElement(component, to: \.component)
    }
    
    /// Appends multiple `ObservationComponent`s to the `Observation`
    @inlinable
    public mutating func appendComponents(_ components: some Sequence<ObservationComponent>) {
        appendElements(components, to: \.component)
    }
}
