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


/// <#Description#>
@Observable
public class FHIRStore {
    @ObservationIgnored private var _resources: [FHIRResource]
    
    
    /// <#Description#>
    public var allergyIntolerances: [FHIRResource] {
        access(keyPath: \.allergyIntolerances)
        return _resources.filter { $0.category == .allergyIntolerance }
    }
    
    /// <#Description#>
    var conditions: [FHIRResource] {
        access(keyPath: \.conditions)
        return _resources.filter { $0.category == .condition }
    }
    
    /// <#Description#>
    var diagnostics: [FHIRResource] {
        access(keyPath: \.diagnostics)
        return _resources.filter { $0.category == .diagnostic }
    }
    
    /// <#Description#>
    var encounters: [FHIRResource] {
        access(keyPath: \.encounters)
        return _resources.filter { $0.category == .encounter }
    }
    
    /// <#Description#>
    var immunizations: [FHIRResource] {
        access(keyPath: \.immunizations)
        return _resources.filter { $0.category == .immunization }
    }
    
    /// <#Description#>
    var medications: [FHIRResource] {
        access(keyPath: \.medications)
        return _resources.filter { $0.category == .medication }
    }
    
    /// <#Description#>
    var observations: [FHIRResource] {
        access(keyPath: \.observations)
        return _resources.filter { $0.category == .observation }
    }
    
    /// <#Description#>
    var otherResources: [FHIRResource] {
        access(keyPath: \.otherResources)
        return _resources.filter { $0.category == .other }
    }
    
    /// <#Description#>
    var procedures: [FHIRResource] {
        access(keyPath: \.procedures)
        return _resources.filter { $0.category == .procedure }
    }
    
    
    init() {
        self._resources = []
    }
    
    
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
    
    /// <#Description#>
    /// - Parameter bundle: <#bundle description#>
    public func load(bundle: Bundle) {
        let resourceProxies = bundle.entry?.compactMap({ $0.resource }) ?? []
        
        for resourceProxy in resourceProxies {
            insert(resource: FHIRResource(resource: resourceProxy.get(), displayName: resourceProxy.resourceType))
        }
    }
    
    /// <#Description#>
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
