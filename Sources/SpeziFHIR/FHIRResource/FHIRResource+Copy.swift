//
//  File.swift
//  SpeziFHIR
//
//  Created by Paul Schmiedmayer on 3/8/25.
//

import Foundation
import ModelsDSTU2
import ModelsR4


extension FHIRResource {
    /// Creates an (expensive) copy of the underlying FHIR reference types by encoding and decoding the FHIR resource in JSON.
    ///
    /// - Warning: The computational complexity of creating a copy should only be used in when creating a new copy is strictly nescessary.
    public func copy() throws -> Self {
        switch versionedResource {
        case let .r4(r4Resource):
            let resource = try JSONDecoder().decode(ModelsR4.ResourceProxy.self, from: try JSONEncoder().encode(r4Resource)).get()
            return .init(resource: resource, displayName: displayName)
        case let .dstu2(dstu2Resource):
            let resource = try JSONDecoder().decode(ModelsDSTU2.ResourceProxy.self, from: try JSONEncoder().encode(dstu2Resource)).get()
            return .init(resource: resource, displayName: displayName)
        }
    }
}
