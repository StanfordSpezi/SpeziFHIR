//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import ModelsR4


extension Observation {
    /// Appends an `Identifier` to the `Observation`
    @inlinable
    public mutating func append(identifier: Identifier) {
        append(identifier, to: \.identifier)
    }
    
    /// Appends multiple `Identifier`s to the `Observation`
    @inlinable
    public mutating func append(identifiers: some Sequence<Identifier>) {
        append(identifiers, to: \.identifier)
    }
    
    /// Appends a `CodeableConcept` to the `Observation`
    @inlinable
    public mutating func append(category: CodeableConcept) {
        append(category, to: \.category)
    }
    
    /// Appends multiple `CodeableConcept`s to the `Observation`
    @inlinable
    public mutating func append(categories: some Sequence<CodeableConcept>) {
        append(categories, to: \.category)
    }
    
    /// Appends a `Coding` to the `Observation`
    @inlinable
    public mutating func append(coding: Coding) {
        append(coding, to: \.code.coding)
    }
    
    /// Appends multiple `Coding`s to the `Observation`
    @inlinable
    public mutating func append(codings: some Sequence<Coding>) {
        append(codings, to: \.code.coding)
    }
    
    /// Appends an `ObservationComponent` to the `Observation`
    @inlinable
    public mutating func append(component: ObservationComponent) {
        append(component, to: \.component)
    }
    
    /// Appends multiple `ObservationComponent`s to the `Observation`
    @inlinable
    public mutating func append(components: some Sequence<ObservationComponent>) {
        append(components, to: \.component)
    }
}
