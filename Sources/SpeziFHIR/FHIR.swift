//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi


/// Spezi standard to support the development of FHIR-based digital health applications.
///
/// > Important: If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) setup the core Spezi infrastructure.
///
/// The standard needs to be registered in a Spezi-based application using the [`configuration`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/speziappdelegate/configuration)
/// in a [`SpeziAppDelegate`](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/speziappdelegate):
/// ```swift
/// class ExampleAppDelegate: SpeziAppDelegate {
///     override var configuration: Configuration {
///         Configuration(standard: FHIR()) {
///             // ...
///         }
///     }
/// }
/// ```
/// > Tip: You can learn more about a [`Standard` in the Spezi documentation](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/standard).
///
///
/// ## Usage
///
/// The ``FHIR`` standard injects an ``FHIRStore`` instance in the SwiftUI environment to handle the storage and management of FHIR resources.
///
/// ```swift
/// class ContentView: View {
///     @Environment(FHIRStore.self) var store
///
///
///     var body: some View {
///         // ...
///     }
/// }
/// ```
///
/// > Tip: You can learn more about how to use the store in the ``FHIRStore`` documentation.
@available(*, deprecated, message: "We recommend using an app-specific `Standard` instead.")
public actor FHIR: Standard {
    @Model public private(set) var store = FHIRStore()
    
    
    public init() {}
}
