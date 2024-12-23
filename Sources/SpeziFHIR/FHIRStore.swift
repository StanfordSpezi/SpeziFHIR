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
    /// Actor-isolated storage for `FHIRResource`s backing the ``FHIRStore``.
    private actor Storage {
        // Non-isolation required so that resource access via the `FHIRStore` stays sync (required for seamless SwiftUI access).
        // Isolation is still guaranteed as the only modifying functions `insert()` and `remove()` are isolated on the `FHIRStore.Storage` actor.
        nonisolated(unsafe) private var _resources: [FHIRResource] = []


        func insert(resource: FHIRResource) {
            _resources.append(resource)
        }

        func remove(resource resourceId: FHIRResource.ID) {
            _resources.removeAll { $0.id == resourceId }
        }

        func removeAll() {
            _resources = []
        }

        nonisolated func fetch(for category: FHIRResource.FHIRResourceCategory) -> [FHIRResource] {
            _resources.filter { $0.category == category }
        }


        subscript(id: FHIRResource.ID) -> FHIRResource? {
            _resources.first { $0.id == id }
        }
    }


    private let storage: Storage


    /// `FHIRResource`s with category `allergyIntolerance`.
    public var allergyIntolerances: [FHIRResource] {
        access(keyPath: \.allergyIntolerances)
        return storage.fetch(for: .allergyIntolerance)
    }

    /// `FHIRResource`s with category `condition`.
    public var conditions: [FHIRResource] {
        access(keyPath: \.conditions)
        return storage.fetch(for: .condition)
    }

    /// `FHIRResource`s with category `diagnostic`.
    public var diagnostics: [FHIRResource] {
        access(keyPath: \.diagnostics)
        return storage.fetch(for: .diagnostic)
    }

    /// `FHIRResource`s with category `encounter`.
    public var encounters: [FHIRResource] {
        access(keyPath: \.encounters)
        return storage.fetch(for: .encounter)
    }

    /// `FHIRResource`s with category `immunization`.
    public var immunizations: [FHIRResource] {
        access(keyPath: \.immunizations)
        return storage.fetch(for: .immunization)
    }

    /// `FHIRResource`s with category `medication`.
    public var medications: [FHIRResource] {
        access(keyPath: \.medications)
        return storage.fetch(for: .medication)
    }

    /// `FHIRResource`s with category `observation`.
    public var observations: [FHIRResource] {
        access(keyPath: \.observations)
        return storage.fetch(for: .observation)
    }

    /// `FHIRResource`s with category `procedure`.
    public var procedures: [FHIRResource] {
        access(keyPath: \.procedures)
        return storage.fetch(for: .procedure)
    }

    /// `FHIRResource`s with category `other`.
    public var otherResources: [FHIRResource] {
        access(keyPath: \.otherResources)
        return storage.fetch(for: .other)
    }


    /// Create an empty ``FHIRStore``.
    public required init() {
        storage = Storage()
    }


    /// Inserts a FHIR resource into the ``FHIRStore``.
    ///
    /// - Parameter resource: The `FHIRResource` to be inserted.
    public func insert(resource: FHIRResource) async {
        _$observationRegistrar.willSet(self, keyPath: resource.storeKeyPath)
        await storage.insert(resource: resource)
        _$observationRegistrar.didSet(self, keyPath: resource.storeKeyPath)
    }

    /// Removes a FHIR resource from the ``FHIRStore``.
    ///
    /// - Parameter resource: The `FHIRResource` identifier to be inserted.
    public func remove(resource resourceId: FHIRResource.ID) async {
        guard let resource = await storage[resourceId] else {
            return
        }

        _$observationRegistrar.willSet(self, keyPath: resource.storeKeyPath)
        await storage.remove(resource: resourceId)
        _$observationRegistrar.didSet(self, keyPath: resource.storeKeyPath)
    }

    /// Loads resources from a given FHIR `Bundle` into the ``FHIRStore``.
    ///
    /// - Parameter bundle: The FHIR `Bundle` containing resources to be loaded.
    public func load(bundle: Bundle) async {
        let resourceProxies = bundle.entry?.compactMap { $0.resource } ?? []

        for resourceProxy in resourceProxies {
            await self.insert(
                resource: FHIRResource(
                    resource: resourceProxy.get(),
                    displayName: resourceProxy.displayName
                )
            )
        }
    }

    /// Removes all resources from the ``FHIRStore``.
    public func removeAllResources() async {
        for category in FHIRResource.FHIRResourceCategory.allCases {
            _$observationRegistrar.willSet(self, keyPath: category.storeKeyPath)
        }

        await storage.removeAll()

        for category in FHIRResource.FHIRResourceCategory.allCases {
            _$observationRegistrar.didSet(self, keyPath: category.storeKeyPath)
        }
    }
}
