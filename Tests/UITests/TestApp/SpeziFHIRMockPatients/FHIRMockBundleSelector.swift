//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SpeziFoundation
import SwiftUI


/// Loads resources from a FHIR bundle from a provided set of mock bundles defined as an extension on `ModelsR4.Bundle`.
///
/// The View assumes that the bundle contains a `ModelsR4.Patient` resource to identify the bundle and provide a human-readable name.
struct FHIRMockPatientSelection: View {
    @State private var isLoading = true
    @State private var bundles: [ModelsR4.Bundle] = []
    
    var body: some View {
        FHIRBundleSelector(bundles: bundles)
            .pickerStyle(.inline)
            .task {
                isLoading = true
                self.bundles = await loadBundles()
                isLoading = false
            }
        if isLoading {
            HStack {
                Text("Loading Mock Patients…")
                    .foregroundStyle(.secondary)
                Spacer()
                ProgressView()
            }
        }
    }
    
    
    @concurrent
    private func loadBundles() async -> [ModelsR4.Bundle] {
        print(Self.self, #function)
        guard let folderUrl = Foundation.Bundle.main.resourceURL,
              let contents = try? FileManager.default.contents(of: folderUrl) else {
            return []
        }
        return contents.compactMap { url in
            guard url.pathExtension == "json" else {
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(ModelsR4.Bundle.self, from: data)
            } catch {
                print("\(url): \(error)")
                return nil
            }
        }
    }
}
