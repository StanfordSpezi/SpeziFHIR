//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

public import struct Foundation.URL
public import ModelsDSTU2
public import ModelsR4


/// Helper type for contructing and managing FHIR Extension URLs.
public struct FHIRExtensionURL: Sendable {
    /// The underlying `URL`.
    public let url: URL
    
    /// Creates a FHIR Extension URL.
    @inlinable
    public init(_ url: URL) {
        self.url = url
    }
    
    /// Creates a FHIR Extension URL from a String.
    ///
    /// - Important: The input String **must** be a valud `URL`; the initializer will otherwise crash the program.
    @inlinable
    public init(_ url: String) {
        #if canImport(Darwin)
        self.url = try! URL(url, strategy: .url) // swiftlint:disable:this force_try
        #else
        // https://github.com/swiftlang/swift-foundation/issues/1919
        self.url = URL(string: url)! // swiftlint:disable:this force_unwrapping
        #endif
    }
}


extension FHIRExtensionURL {
    /// R4 `FHIRPrimitive<FHIRURI>`
    @inlinable public var r4: ModelsR4.FHIRPrimitive<ModelsR4.FHIRURI> { // swiftlint:disable:this identifier_name
        url.asFHIRURIPrimitive()
    }
    
    /// DSTU2 `FHIRPrimitive<FHIRURI>`
    @inlinable public var dstu2: ModelsDSTU2.FHIRPrimitive<ModelsDSTU2.FHIRURI> {
        url.asFHIRURIPrimitive()
    }
}


extension FHIRExtensionURL {
    /// Creates a new `FHIRExtensionURL` by appending a component.
    @inlinable
    public func appending(component: some StringProtocol) -> Self {
        Self(url.appending(component: component))
    }
    
    /// Creates a new `FHIRExtensionURL>` by appending multiple components.
    @inlinable
    public func appending(components: some Sequence<some StringProtocol>) -> Self {
        var url = url
        for component in components {
            url = url.appending(component: component)
        }
        return Self(url)
    }
}


// MARK: FHIR Helpers

// swiftlint:disable missing_docs discouraged_optional_collection function_default_parameter_at_end

extension ModelsR4.Extension {
    @inlinable
    public init(
        `extension`: [ModelsR4.Extension]? = nil,
        id: ModelsR4.FHIRPrimitive<ModelsR4.FHIRString>? = nil,
        url: FHIRExtensionURL,
        value: ModelsR4.Extension.ValueX? = nil
    ) {
        self.init(extension: `extension`, id: id, url: url.r4, value: value)
    }
}
