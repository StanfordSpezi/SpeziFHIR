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
    // The `_resources` array needs to be marked with `@ObservationIgnored` to prevent changes to this array
    // from triggering updates to all computed properties.
    // Instead, we explicitly control change notifications through `willSet`/`didSet` calls
    // with specific keyPaths in the `insert`, `remove`, and other mutation methods. This ensures that
    // only observers of the relevant category (e.g., observations, conditions) are notified when
    // resources of that category are modified.
    @ObservationIgnored @MainActor private var _resources: Set<FHIRResource> = []
    @ObservationIgnored @Dependency(HealthKit.self) package var healthKit


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


    /// Inserts a FHIR resource into the ``FHIRStore``.
    ///
    /// - Parameter resource: The `FHIRResource` to be inserted.
    @MainActor
    @discardableResult
    public func insert(resource: FHIRResource) -> Bool {
        guard !_resources.contains(resource) else {
            return false
        }
        _$observationRegistrar.willSet(self, keyPath: resource.category.storeKeyPath)
        _resources.insert(resource)
        _$observationRegistrar.didSet(self, keyPath: resource.category.storeKeyPath)
        return true
    }

    /// Inserts a ``Collection`` of FHIR resources into the ``FHIRStore``.
    ///
    /// - Parameter resources: The `FHIRResource`s to be inserted.
    @MainActor
    public func insert(resources: some Collection<FHIRResource>) {
        let resources = resources.filter { !_resources.contains($0) }
        let resourceCategories = Array(resources.mapIntoSet(\.category))
        for category in resourceCategories {
            _$observationRegistrar.willSet(self, keyPath: category.storeKeyPath)
        }
        _resources.formUnion(resources)
        for category in resourceCategories.reversed() {
            _$observationRegistrar.didSet(self, keyPath: category.storeKeyPath)
        }
    }

    /// Loads resources from a given FHIR `Bundle` into the ``FHIRStore``.
    ///
    /// - Parameter bundle: The FHIR `Bundle` containing resources to be loaded.
    public func load(bundle: sending Bundle) async {
        let resourceProxies = bundle.entry?.compactMap { $0.resource } ?? []
        var resources: [FHIRResource] = []

        for resourceProxy in resourceProxies {
            if Task.isCancelled {
                return
            }

            resources.append(
                FHIRResource(
                    resource: resourceProxy.get(),
                    displayName: resourceProxy.displayName
                )
            )
        }

        if Task.isCancelled {
            return
        }

        await insert(resources: resources)
    }

    /// Removes a FHIR resource from the ``FHIRStore``.
    ///
    /// - Parameter fhirId: The FHIR `id` of the resource that should be removed.
    @MainActor
    public func removeResource(withId fhirId: String) {
        guard let resource = _resources.first(where: { $0.fhirId == fhirId }) else {
            return
        }
        _$observationRegistrar.willSet(self, keyPath: resource.category.storeKeyPath)
        _resources.removeAll { $0.fhirId == fhirId }
        _$observationRegistrar.didSet(self, keyPath: resource.category.storeKeyPath)
    }
    
    /// Removes a FHIR resource from the ``FHIRStore``.
    ///
    /// - Parameter healthKitId: The HealthKit `uuid` of the resource that should be removed.
    @_spi(Internal)
    @MainActor
    public func removeResource(withHealthKitUUID healthKitId: String) {
        guard let resource = _resources.first(where: { $0.healthKitSampleId == healthKitId }) else {
            return
        }
        _$observationRegistrar.willSet(self, keyPath: resource.category.storeKeyPath)
        _resources.removeAll { $0.healthKitSampleId == healthKitId }
        _$observationRegistrar.didSet(self, keyPath: resource.category.storeKeyPath)
    }

    /// Removes all resources from the ``FHIRStore``.
    @MainActor
    public func removeAllResources() {
        for category in FHIRResource.FHIRResourceCategory.allCases {
            _$observationRegistrar.willSet(self, keyPath: category.storeKeyPath)
        }
        _resources = []
        for category in FHIRResource.FHIRResourceCategory.allCases {
            _$observationRegistrar.didSet(self, keyPath: category.storeKeyPath)
        }
    }
}


extension Set {
    fileprivate mutating func removeAll(where predicate: (Element) -> Bool) {
        for element in self where predicate(element) {
            remove(element)
        }
    }
}
