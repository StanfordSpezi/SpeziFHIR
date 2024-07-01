//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@preconcurrency import class ModelsR4.Bundle


extension Foundation.Bundle {
    /// Loads a FHIR `Bundle` from a Foundation `Bundle`.
    /// - Parameter name: Name of the JSON file in the Foundation `Bundle`
    /// - Returns: The FHIR `Bundle`
    public func loadFHIRBundle(withName name: String) async -> Bundle {
        guard let resourceURL = Self.module.url(forResource: name, withExtension: "json") else {
            fatalError("Could not find the resource \"\(name)\".json in the SpeziFHIRMockPatients Resources folder.")
        }
        
        let loadingTask = Task {
            let resourceData = try Data(contentsOf: resourceURL)
            return try JSONDecoder().decode(Bundle.self, from: resourceData)
        }
        
        do {
            return try await loadingTask.value
        } catch {
            fatalError("Could not decode the FHIR bundle named \"\(name).json\": \(error)")
        }
    }
}
