//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import class ModelsR4.Bundle
import class ModelsR4.Patient
import SpeziFHIR
import SwiftUI


/// Loads resources from a FHIR bundle from a provided set of bundles.
///
/// The View assumes that the bundle contains a `ModelsR4.Patient` resource to identify the bundle and provide a human-readable name.
public struct FHIRBundleSelector: View {
    private struct PatientIdentifiedBundle: Identifiable, Sendable {
        let id: String
        let bundle: ModelsR4.Bundle
    }


    @Environment(FHIRStore.self) private var store
    @State private var selectedBundleId: PatientIdentifiedBundle.ID?

    private let bundles: [PatientIdentifiedBundle]


    public var body: some View {
        Picker(
            String(localized: "Select Mock Patient", bundle: .module),
            selection: $selectedBundleId
        ) {
            ForEach(bundles) { bundle in
                Text(bundle.bundle.patientName)
                    .tag(bundle.id as String?)
            }
        }
            // Load the currently stored patient data to update `selectedBundleID`
            .task {
                let existingResources = store.otherResources
                guard
                    let patient = existingResources.compactMap({ resource -> Patient? in
                        guard case let .r4(r4Resource) = resource.versionedResource,
                              let loadedPatient = r4Resource as? Patient else {
                            return nil
                        }

                        return loadedPatient
                    }).first,
                    let matchedBundle = bundles.first(where: {
                        patient.identifier == $0.bundle.patient?.identifier
                    })
                else {
                    return
                }
                selectedBundleId = matchedBundle.id
            }
            // Remove existing resources and load the newly selected bundle
            .onChange(of: selectedBundleId) { _, newValue in
                Task {
                    guard let newValue,
                          let selected = bundles.first(where: { $0.id == newValue }) else {
                        return
                    }

                    await store.removeAllResources()
                    await store.load(bundle: selected.bundle)
                }
            }
    }
    
    
    public init(bundles: [ModelsR4.Bundle]) {
        self.bundles = bundles.compactMap {
            guard let id = $0.patient?.identifier?.first?.value?.value?.string else {
                return nil
            }
            
            return PatientIdentifiedBundle(id: id, bundle: $0)
        }
    }
}
