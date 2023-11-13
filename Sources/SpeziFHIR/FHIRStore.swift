//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Combine
import Observation
import class ModelsR4.Bundle
import enum ModelsDSTU2.ResourceProxy


/// Manage FHIR resources grouped into automatically computed and updated categories.
@Observable
public class FHIRStore {
    @ObservationIgnored private var _resources: [FHIRResource]
    
    
    /// Allergy intolerances.
    public var allergyIntolerances: [FHIRResource] {
        access(keyPath: \.allergyIntolerances)
        return _resources.filter { $0.category == .allergyIntolerance }
    }
    
    /// Conditions.
    var conditions: [FHIRResource] {
        access(keyPath: \.conditions)
        return _resources.filter { $0.category == .condition }
    }
    
    /// Diagnostics.
    var diagnostics: [FHIRResource] {
        access(keyPath: \.diagnostics)
        return _resources.filter { $0.category == .diagnostic }
    }
    
    /// Encounters.
    var encounters: [FHIRResource] {
        access(keyPath: \.encounters)
        return _resources.filter { $0.category == .encounter }
    }
    
    /// Immunizations.
    var immunizations: [FHIRResource] {
        access(keyPath: \.immunizations)
        return _resources.filter { $0.category == .immunization }
    }
    
    /// Medications.
    var medications: [FHIRResource] {
        access(keyPath: \.medications)
        return _resources.filter { $0.category == .medication }
    }
    
    /// Observations.
    var observations: [FHIRResource] {
        access(keyPath: \.observations)
        return _resources.filter { $0.category == .observation }
    }
    
    /// Other resources that could not be classified on the other categories.
    var otherResources: [FHIRResource] {
        access(keyPath: \.otherResources)
        return _resources.filter { $0.category == .other }
    }
    
    /// Procedures.
    var procedures: [FHIRResource] {
        access(keyPath: \.procedures)
        return _resources.filter { $0.category == .procedure }
    }
    
    
    init() {
        self._resources = []
    }
    
    
    /// Inserts a FHIR resource into the store.
    /// The resource is appended to the appropriate category based on its type.
    /// - Parameter resource: The `FHIRResource` to be inserted.
    public func insert(resource: FHIRResource) {
        switch resource.category {
        case .allergyIntolerance:
            withMutation(keyPath: \.allergyIntolerances) {
                _resources.append(resource)
            }
        case .condition:
            withMutation(keyPath: \.conditions) {
                _resources.append(resource)
            }
        case .diagnostic:
            withMutation(keyPath: \.diagnostics) {
                _resources.append(resource)
            }
        case .encounter:
            withMutation(keyPath: \.encounters) {
                _resources.append(resource)
            }
        case .immunization:
            withMutation(keyPath: \.immunizations) {
                _resources.append(resource)
            }
        case .medication:
            withMutation(keyPath: \.medications) {
                _resources.append(resource)
            }
        case .observation:
            withMutation(keyPath: \.observations) {
                _resources.append(resource)
            }
        case .other:
            withMutation(keyPath: \.otherResources) {
                _resources.append(resource)
            }
        case .procedure:
            withMutation(keyPath: \.procedures) {
                _resources.append(resource)
            }
        }
    }
    
    /// Loads resources from a given FHIR `Bundle`.
    ///
    /// - Parameter bundle: The FHIR `Bundle` containing resources to be loaded.
    public func load(bundle: Bundle) {
        let resourceProxies = bundle.entry?.compactMap { $0.resource } ?? []
        
        for resourceProxy in resourceProxies {
            insert(resource: FHIRResource(resource: resourceProxy.get(), displayName: resourceProxy.resourceType))
        }
    }
    
    /// Removes all resources from the store.
    public func removeAllResources() {
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
