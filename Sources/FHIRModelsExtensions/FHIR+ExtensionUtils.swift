//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable file_types_order attributes discouraged_optional_collection

public import ModelsR4


// MARK: Retrieval

extension ModelsR4._FHIRTypeWithExtensions {
    /// Retrieves all FHIR Extensions for the specified url.
    @inlinable
    public func extensions(for url: FHIRPrimitive<FHIRURI>) -> [Extension] {
        `extension`.map { $0.filter { $0.url == url } } ?? []
    }
    
    /// Retrieves all FHIR Extensions for the specified url.
    @inlinable
    public func extensions(for url: FHIRExtensionURL) -> [Extension] {
        extensions(for: url.r4)
    }
}


// MARK: Appending

/// Controls extension appending
public enum AppendExtensionBehaviour {
    /// Adding an extension does not affect existing extensions with the same URL, instead the new value simply gets appended.
    case additive
    /// Adding an extension causes all other existing extensions with the same URL to be removed.
    case replace
}


extension ModelsR4._FHIRTypeWithExtensions {
    /// Appends an `Extension`
    ///
    /// - parameter extension: The extension to add
    /// - parameter replaceExisting: Whether
    @inlinable
    public mutating func append(extension: Extension, behaviour: AppendExtensionBehaviour = .additive) {
        append(extensions: CollectionOfOne(`extension`), behaviour: behaviour)
    }
    
    /// Appends multiple `Extension`s
    @inlinable
    public mutating func append(extensions: some Sequence<Extension>, behaviour: AppendExtensionBehaviour = .additive) {
        switch behaviour {
        case .additive:
            break
        case .replace:
            for element in extensions {
                removeAllExtensions(withUrl: element.url)
            }
        }
        appendElements(extensions, to: \.extension)
    }
}


// MARK: Removal

extension ModelsR4._FHIRTypeWithExtensions {
    /// Removes the first extension that matches the specified url.
    ///
    /// - returns: the removed extension element, if any.
    @inlinable @discardableResult
    public mutating func removeFirstExtension(withUrl url: FHIRPrimitive<FHIRURI>) -> Extension? {
        removeFirstElement(of: \.extension) { $0.url == url }
    }
    
    /// Removes the first extension that matches the specified url.
    ///
    /// - returns: the removed extension element, if any.
    @inlinable @discardableResult
    public mutating func removeFirstExtension(withUrl url: FHIRExtensionURL) -> Extension? {
        removeFirstExtension(withUrl: url.r4)
    }
    
    
    /// Removes all extension that matches the specified url.
    ///
    /// - returns: the removed extension elements, if any.
    @inlinable @discardableResult
    public mutating func removeAllExtensions(withUrl url: FHIRPrimitive<FHIRURI>) -> [Extension]? {
        removeAllElements(of: \.extension) { $0.url == url }
    }
    
    /// Removes all extension that matches the specified url.
    ///
    /// - returns: the removed extension elements, if any.
    @inlinable @discardableResult
    public mutating func removeAllExtensions(withUrl url: FHIRExtensionURL) -> [Extension]? {
        removeAllExtensions(withUrl: url.r4)
    }
}
