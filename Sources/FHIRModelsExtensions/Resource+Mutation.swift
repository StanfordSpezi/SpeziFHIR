//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import FMCore


extension FHIRType {
    /// Appends an element to a `Collection`-typed property.
    @inlinable
    public mutating func append<C: RangeReplaceableCollection>(_ element: C.Element, to keyPath: WritableKeyPath<Self, C?>) {
        append(CollectionOfOne(element), to: keyPath)
    }
    
    /// Appends multiple elements to a `Collection`-typed property.
    @inlinable
    public mutating func append<C: RangeReplaceableCollection>(
        _ elements: some Sequence<C.Element>,
        to keyPath: WritableKeyPath<Self, C?>
    ) {
        if self[keyPath: keyPath] == nil {
            self[keyPath: keyPath] = C()
            // swiftlint:disable force_unwrapping
            self[keyPath: keyPath]!.reserveCapacity(elements.underestimatedCount)
        } else {
            self[keyPath: keyPath]!.reserveCapacity(
                self[keyPath: keyPath]!.count + elements.underestimatedCount
            )
            // swiftlint:enable force_unwrapping
        }
        self[keyPath: keyPath]?.append(contentsOf: elements)
    }
    
    /// Removes the first element of the property that matches the predicate.
    ///
    /// Also sets the property to `nil` if there are no elements remaining after the removal.
    ///
    /// - returns: the removed element, if any.
    @inlinable
    public mutating func removeFirst<C: RangeReplaceableCollection>(
        of keyPath: WritableKeyPath<Self, C?>,
        where predicate: (C.Element) -> Bool
    ) -> C.Element? {
        guard var elements = self[keyPath: keyPath], let idx = elements.firstIndex(where: predicate) else {
            return nil
        }
        let element = elements.remove(at: idx)
        self[keyPath: keyPath] = elements.isEmpty ? nil : elements
        return element
    }
    
    /// Removes all elements of the property that matche the predicate.
    ///
    /// Also sets the property to `nil` if there are no elements remaining after the removal.
    ///
    /// - returns: the removed elements, if any.
    @inlinable
    public mutating func removeAll<C: RangeReplaceableCollection>(
        of keyPath: WritableKeyPath<Self, C?>,
        where predicate: (C.Element) -> Bool
    ) -> [C.Element]? { // swiftlint:disable:this discouraged_optional_collection
        guard var elements = self[keyPath: keyPath] else {
            return nil
        }
        let indices = elements.indices.filter { predicate(elements[$0]) }
        let removedElements = indices.map { elements[$0] }
        elements.removeElements(at: indices)
        self[keyPath: keyPath] = elements.isEmpty ? nil : elements
        return removedElements
    }
}


extension RangeReplaceableCollection {
    @inlinable
    mutating func removeElements(at indices: some Collection<Index>) {
        for idx in indices.sorted().reversed() {
            self.remove(at: idx)
        }
    }
}
