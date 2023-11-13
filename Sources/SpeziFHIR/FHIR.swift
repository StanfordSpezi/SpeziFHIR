//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi


public actor FHIR: Standard {
    @Model private var store: FHIRStore
    
    
    public init() {
        self._store = Model(wrappedValue: FHIRStore())
    }
    
    
    public func insert(resource: FHIRResource) {
        store.insert(resource: resource)
    }
}
