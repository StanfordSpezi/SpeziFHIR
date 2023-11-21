//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import ModelsR4
import SwiftUI


/// Loads resources from a FHIR bundle from a provided set of mock bundles defined as an extension on `ModelsR4.Bundle`.
///
/// The View assumes that the bundle contains a `ModelsR4.Patient` resource to identify the bundle and provide a human-readable name.
public struct FHIRMockPatientSelection: View {
    @State var bundles: [ModelsR4.Bundle] = []
    
    
    public var body: some View {
        Group {
            if bundles.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                FHIRBundleSelector(bundles: bundles)
                    .pickerStyle(.inline)
            }
        }
            .task {
                self.bundles = await ModelsR4.Bundle.mockPatients
            }
    }
    
    
    public init() { }
}
