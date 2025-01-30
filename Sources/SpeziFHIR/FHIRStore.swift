//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

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
                             Sendable {
    
    // The `_resources` array needs to be marked with `@ObservationIgnored` to prevent changes to this array
    // from triggering updates to all computed properties.
    // Instead, we explicitly control change notifications through `willSet`/`didSet` calls
    // with specific keyPaths in the `insert`, `remove`, and other mutation methods. This ensures that
    // only observers of the relevant category (e.g., observations, conditions) are notified when
    // resources of that category are modified.
    @ObservationIgnored @MainActor private var _resources: [FHIRResource] = []


    /// `FHIRResource`s with category `allergyIntolerance`.
    @MainActor public var allergyIntolerances: [FHIRResource] {
        access(keyPath: \.allergyIntolerances)
        return _resources.filter { $0.category == .allergyIntolerance }
    }

    /// `FHIRResource`s with category `condition`.
    @MainActor public var conditions: [FHIRResource] {
        access(keyPath: \.conditions)
        return _resources.filter { $0.category == .condition }
    }

    /// `FHIRResource`s with category `diagnostic`.
    @MainActor public var diagnostics: [FHIRResource] {
        access(keyPath: \.diagnostics)
        return _resources.filter { $0.category == .diagnostic }
    }

    /// `FHIRResource`s with category `encounter`.
    @MainActor public var encounters: [FHIRResource] {
        access(keyPath: \.encounters)
        return _resources.filter { $0.category == .encounter }
    }

    /// `FHIRResource`s with category `immunization`
    @MainActor public var immunizations: [FHIRResource] {
        access(keyPath: \.immunizations)
        return _resources.filter { $0.category == .immunization }
    }

    /// `FHIRResource`s with category `medication`.
    @MainActor public var medications: [FHIRResource] {
        access(keyPath: \.medications)
        return _resources.filter { $0.category == .medication }
    }

    /// `FHIRResource`s with category `observation`.
    @MainActor public var observations: [FHIRResource] {
        access(keyPath: \.observations)
        return _resources.filter { $0.category == .observation }
    }

    /// `FHIRResource`s with category `procedure`.
    @MainActor public var procedures: [FHIRResource] {
        access(keyPath: \.procedures)
        return _resources.filter { $0.category == .procedure }
    }

    /// `FHIRResource`s with category `other`.
    @MainActor public var otherResources: [FHIRResource] {
        access(keyPath: \.otherResources)
        return _resources.filter { $0.category == .other }
    }


    /// Create an empty ``FHIRStore``.
    public required init() {}


    /// Inserts a FHIR resource into the ``FHIRStore``.
    ///
    /// - Parameter resource: The `FHIRResource` to be inserted.
    @MainActor
    public func insert(resource: FHIRResource) {
        _$observationRegistrar.willSet(self, keyPath: resource.category.storeKeyPath)

        _resources.append(resource)

        _$observationRegistrar.didSet(self, keyPath: resource.category.storeKeyPath)
    }

    /// Inserts a ``Collection`` of FHIR resources into the ``FHIRStore``.
    ///
    /// - Parameter resources: The `FHIRResource`s to be inserted.
    @MainActor
    public func insert<T: Collection>(resources: T) where T.Element == FHIRResource {
        let resourceCategories = Set(resources.map(\.category))

        for category in resourceCategories {
            _$observationRegistrar.willSet(self, keyPath: category.storeKeyPath)
        }

        self._resources.append(contentsOf: resources)

        for category in resourceCategories {
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
    /// - Parameter resource: The `FHIRResource` identifier to be inserted.
    @MainActor
    public func remove(resource resourceId: FHIRResource.ID) {
        guard let resource = _resources.first(where: { $0.id == resourceId }) else {
            return
        }

        _$observationRegistrar.willSet(self, keyPath: resource.category.storeKeyPath)

        _resources.removeAll { $0.id == resourceId }

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
