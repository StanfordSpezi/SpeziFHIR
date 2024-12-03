//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Combine
import Foundation
import Observation
import class ModelsR4.Bundle
import enum ModelsDSTU2.ResourceProxy
import Spezi


/// `Module` to manage FHIR resources grouped into automatically computed and updated categories.
///
/// The ``FHIRStore`` is automatically injected in the environment if you use the ``FHIR`` standard or can be used as a standalone module.
@Observable
public final class FHIRStore: Module,
                              EnvironmentAccessible,
                              DefaultInitializable,
                              @unchecked Sendable /* `unchecked` `Sendable` conformance fine as access to `_resources` protected by `NSLock` */ {
    private let lock = NSLock()
    @ObservationIgnored private var _resources: [FHIRResource]
    
    
    /// Allergy intolerances.
    public var allergyIntolerances: [FHIRResource] {
        access(keyPath: \.allergyIntolerances)
        return lock.withLock {
            _resources.filter { $0.category == .allergyIntolerance }
        }
    }
    
    /// Conditions.
    public var conditions: [FHIRResource] {
        access(keyPath: \.conditions)
        return lock.withLock {
            _resources.filter { $0.category == .condition }
        }
    }
    
    /// Diagnostics.
    public var diagnostics: [FHIRResource] {
        access(keyPath: \.diagnostics)
        return lock.withLock {
            _resources.filter { $0.category == .diagnostic }
        }
    }
    
    /// Encounters.
    public var encounters: [FHIRResource] {
        access(keyPath: \.encounters)
        return _resources.filter { $0.category == .encounter }
    }
    
    /// Immunizations.
    public var immunizations: [FHIRResource] {
        access(keyPath: \.immunizations)
        return lock.withLock {
            _resources.filter { $0.category == .immunization }
        }
    }
    
    /// Medications.
    public var medications: [FHIRResource] {
        access(keyPath: \.medications)
        return lock.withLock {
            _resources.filter { $0.category == .medication }
        }
    }
    
    /// Observations.
    public var observations: [FHIRResource] {
        access(keyPath: \.observations)
        return lock.withLock {
            _resources.filter { $0.category == .observation }
        }
    }
    
    /// Other resources that could not be classified on the other categories.
    public var otherResources: [FHIRResource] {
        access(keyPath: \.otherResources)
        return lock.withLock {
            _resources.filter { $0.category == .other }
        }
    }
    
    /// Procedures.
    public var procedures: [FHIRResource] {
        access(keyPath: \.procedures)
        return lock.withLock {
            _resources.filter { $0.category == .procedure }
        }
    }
    
    
    public required init() {
        self._resources = []
    }
    
    
    /// Inserts a FHIR resource into the store.
    ///
    /// - Parameter resource: The `FHIRResource` to be inserted.
    public func insert(resource: FHIRResource) {
        withMutation(keyPath: resource.storeKeyPath) {
            lock.withLock {
                _resources.append(resource)
            }
        }
    }
    
    /// Removes a FHIR resource from the store.
    ///
    /// - Parameter resource: The `FHIRResource` identifier to be inserted.
    public func remove(resource resourceId: FHIRResource.ID) {
        lock.withLock {
            guard let resource = _resources.first(where: { $0.id == resourceId }) else {
                return
            }
            
            withMutation(keyPath: resource.storeKeyPath) {
                _resources.removeAll(where: { $0.id == resourceId })
            }
        }
    }
    
    /// Loads resources from a given FHIR `Bundle`.
    ///
    /// - Parameter bundle: The FHIR `Bundle` containing resources to be loaded.
    public func load(bundle: Bundle) {
        let resourceProxies = bundle.entry?.compactMap { $0.resource } ?? []
        
        for resourceProxy in resourceProxies {
            insert(resource: FHIRResource(resource: resourceProxy.get(), displayName: resourceProxy.displayName))
        }
    }
    
    /// Removes all resources from the store.
    public func removeAllResources() {
        lock.withLock {
            // Not really ideal but seems to be a path to ensure that all observables are called.
            _$observationRegistrar.willSet(self, keyPath: \.allergyIntolerances)
            _$observationRegistrar.willSet(self, keyPath: \.conditions)
            _$observationRegistrar.willSet(self, keyPath: \.diagnostics)
            _$observationRegistrar.willSet(self, keyPath: \.encounters)
            _$observationRegistrar.willSet(self, keyPath: \.immunizations)
            _$observationRegistrar.willSet(self, keyPath: \.medications)
            _$observationRegistrar.willSet(self, keyPath: \.observations)
            _$observationRegistrar.willSet(self, keyPath: \.otherResources)
            _$observationRegistrar.willSet(self, keyPath: \.procedures)
            _resources = []
            _$observationRegistrar.didSet(self, keyPath: \.allergyIntolerances)
            _$observationRegistrar.didSet(self, keyPath: \.conditions)
            _$observationRegistrar.didSet(self, keyPath: \.diagnostics)
            _$observationRegistrar.didSet(self, keyPath: \.encounters)
            _$observationRegistrar.didSet(self, keyPath: \.immunizations)
            _$observationRegistrar.didSet(self, keyPath: \.medications)
            _$observationRegistrar.didSet(self, keyPath: \.observations)
            _$observationRegistrar.didSet(self, keyPath: \.otherResources)
            _$observationRegistrar.didSet(self, keyPath: \.procedures)
        }
    }
}
