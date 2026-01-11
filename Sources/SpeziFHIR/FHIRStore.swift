//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import enum ModelsDSTU2.ResourceProxy
import class ModelsR4.Bundle
import Observation
import Spezi
import SpeziHealthKit


/// `Module` to manage FHIR resources grouped into automatically computed and updated categories.
///
/// The ``FHIRStore`` is automatically injected in the environment if you use the ``FHIR`` standard or can be used as a standalone module.
@Observable
public final class FHIRStore: Module, EnvironmentAccessible, DefaultInitializable, @unchecked Sendable { // unchecked bc of the HealthKit dependency
    @ObservationIgnored @Dependency(HealthKit.self) package var healthKit
    
    /// The actual ``FHIRResource``s held by the ``FHIRStore``
    ///
    /// The `_resources` property needs to be marked with `@ObservationIgnored` to prevent changes to it
    /// from triggering updates to all computed properties.
    /// Instead, we explicitly control change notifications through `willSet`/`didSet` calls
    /// with specific keyPaths in the `insert`, `remove`, and other mutation methods.
    /// This ensures that only observers of the relevant category (e.g., observations, conditions) are notified when
    /// resources of that category are modified.
    /// See also the `mutatingResourceCategories` function
    @ObservationIgnored @MainActor @usableFromInline var _resources: Set<FHIRResource> = [] // swiftlint:disable:this identifier_name
    
    
    /// `FHIRResource`s with category `allergyIntolerance`.
    @MainActor public var allergyIntolerances: Set<FHIRResource> {
        access(keyPath: \.allergyIntolerances)
        return _resources.filter { $0.category == .allergyIntolerance }
    }
    
    /// `FHIRResource`s with category `condition`.
    @MainActor public var conditions: Set<FHIRResource> {
        access(keyPath: \.conditions)
        return _resources.filter { $0.category == .condition }
    }
    
    /// `FHIRResource`s with category `diagnostic`.
    @MainActor public var diagnostics: Set<FHIRResource> {
        access(keyPath: \.diagnostics)
        return _resources.filter { $0.category == .diagnostic }
    }
    
    /// `FHIRResource`s with category `documentReference`.
    @MainActor public var documents: Set<FHIRResource> {
        access(keyPath: \.documents)
        return _resources.filter { $0.category == .document }
    }
    
    /// `FHIRResource`s with category `encounter`.
    @MainActor public var encounters: Set<FHIRResource> {
        access(keyPath: \.encounters)
        return _resources.filter { $0.category == .encounter }
    }
    
    /// `FHIRResource`s with category `immunization`
    @MainActor public var immunizations: Set<FHIRResource> {
        access(keyPath: \.immunizations)
        return _resources.filter { $0.category == .immunization }
    }
    
    /// `FHIRResource`s with category `medication`.
    @MainActor public var medications: Set<FHIRResource> {
        access(keyPath: \.medications)
        return _resources.filter { $0.category == .medication }
    }
    
    /// `FHIRResource`s with category `observation`.
    @MainActor public var observations: Set<FHIRResource> {
        access(keyPath: \.observations)
        return _resources.filter { $0.category == .observation }
    }
    
    /// `FHIRResource`s with category `procedure`.
    @MainActor public var procedures: Set<FHIRResource> {
        access(keyPath: \.procedures)
        return _resources.filter { $0.category == .procedure }
    }
    
    /// `FHIRResource`s with category `other`.
    @MainActor public var otherResources: Set<FHIRResource> {
        access(keyPath: \.otherResources)
        return _resources.filter { $0.category == .other }
    }
    
    
    /// Create an empty ``FHIRStore``.
    public required init() {}
}


// MARK: FHIRStore Resource Insertion

extension FHIRStore {
    /// Inserts a FHIR resource into the ``FHIRStore``, unless it is already in the store.
    ///
    /// - parameter resource: The `FHIRResource` to be inserted.
    /// - returns: A `Bool` indicating whether the resource was inserted into the store. (I.e., `false` if the store already contained a resource with an equivalent id.)
    @MainActor
    @discardableResult
    public func insert(_ resource: FHIRResource) -> Bool {
        guard !self.contains(resource) else {
            return false
        }
        return mutatingResourceCategories(CollectionOfOne(resource.category)) {
            _resources.insert(resource).inserted
        }
    }
    
    /// Inserts multiple ``FHIRResource``s into the store.
    ///
    /// Any resources that already exist in the store will be skipped; only new resources will be inserted
    ///
    /// - Parameter resources: The `FHIRResource`s to be inserted.
    @MainActor
    public func insert(contentsOf resourcesToInsert: some Sequence<FHIRResource>) {
        let resourcesToInsert = resourcesToInsert.filter { !self._resources.contains($0) }
        guard !resourcesToInsert.isEmpty else {
            return
        }
        mutatingResourceCategories(resourcesToInsert.lazy.map(\.category)) {
            _resources.formUnion(resourcesToInsert)
        }
    }
    
    /// Loads resources from a given FHIR `Bundle` into the ``FHIRStore``.
    ///
    /// - Parameter bundle: The FHIR `Bundle` containing resources to be loaded.
    @MainActor
    public func load(bundle: sending Bundle) {
        guard let resourceProxies = bundle.entry?.compactMap(\.resource), !resourceProxies.isEmpty else {
            return
        }
        insert(contentsOf: resourceProxies.lazy.map {
            FHIRResource(resource: $0.get(), displayName: $0.displayName)
        })
    }
}


// MARK: FHIRStore Resource Removal

extension FHIRStore {
    /// Removes a FHIR resource from the ``FHIRStore``.
    ///
    /// - Parameter fhirId: The FHIR `id` of the resource that should be removed.
    /// - returns: The removed ``FHIRResource``, if applicable.
    @MainActor
    @discardableResult
    public func removeResource(withId fhirId: String) -> FHIRResource? {
        guard let resource = _resources.first(where: { $0.fhirId == fhirId }) else {
            return nil
        }
        return mutatingResourceCategories(CollectionOfOne(resource.category)) {
            _resources.remove(resource)
        }
    }
    
    /// Removes a FHIR resource from the ``FHIRStore``.
    ///
    /// - Parameter healthKitId: The HealthKit `uuid` of the resource that should be removed.
    /// - returns: The removed ``FHIRResource``, if applicable.
    @_spi(Internal)
    @MainActor
    @discardableResult
    public func removeResource(withHealthKitUUID healthKitId: String) -> FHIRResource? {
        guard let resource = _resources.first(where: { $0.healthKitSampleId == healthKitId }) else {
            return nil
        }
        return mutatingResourceCategories(CollectionOfOne(resource.category)) {
            _resources.remove(resource)
        }
    }
    
    /// Removes all ``FHIRResource``s that satisfy the predicate.
    @MainActor
    public func removeAllResources(where predicate: (FHIRResource) throws -> Bool) rethrows {
        let resourcesToRemove = try _resources.filter(predicate)
        guard !resourcesToRemove.isEmpty else {
            return
        }
        mutatingResourceCategories(resourcesToRemove.lazy.map(\.category)) {
            _resources.subtract(resourcesToRemove)
        }
    }
    
    /// Removes all resources from the ``FHIRStore``.
    @MainActor
    public func removeAllResources() {
        removeAllResources { _ in true }
    }
}


// MARK: FHIRStore Helpers

extension FHIRStore {
    @MainActor
    private func mutatingResourceCategories<Result>(
        _ categories: some Sequence<FHIRResource.FHIRResourceCategory>,
        _ operation: () -> Result
    ) -> Result {
        let categories = Array(Set(categories))
        for category in categories {
            _$observationRegistrar.willSet(self, keyPath: category.storeKeyPath)
        }
        let result = operation()
        for category in categories.reversed() {
            _$observationRegistrar.didSet(self, keyPath: category.storeKeyPath)
        }
        return result
    }
}


// MARK: FHIRStore + Collection

extension FHIRStore: @MainActor Collection {
    public typealias Element = FHIRResource
    
    public struct Index: Comparable {
        @usableFromInline let _index: Set<FHIRResource>.Index // swiftlint:disable:this identifier_name
        
        @inlinable
        init(_ index: Set<FHIRResource>.Index) {
            _index = index
        }
        
        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs._index < rhs._index
        }
    }
    
    
    @MainActor @inlinable public var isEmpty: Bool {
        _resources.isEmpty
    }
    
    @MainActor @inlinable public var startIndex: Index {
        Index(_resources.startIndex)
    }
    
    @MainActor @inlinable public var endIndex: Index {
        Index(_resources.endIndex)
    }
    
    @MainActor
    @inlinable
    public func _customContainsEquatableElement( // swiftlint:disable:this identifier_name
        _ element: FHIRResource
    ) -> Bool? { // swiftlint:disable:this discouraged_optional_boolean
        _resources.contains(element)
    }
    
    @MainActor
    @inlinable
    public func index(after idx: Index) -> Index {
        Index(_resources.index(after: idx._index))
    }
    
    @MainActor
    @inlinable
    public subscript(position: Index) -> FHIRResource {
        _resources[position._index]
    }
}
