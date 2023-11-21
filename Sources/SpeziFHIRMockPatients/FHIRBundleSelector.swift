//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import class ModelsR4.Bundle
import class ModelsR4.Patient
import SpeziFHIR
import SwiftUI


/// Loads resources from a FHIR bundle from a provided set of bundles.
///
/// The View assumes that the bundle contains a `ModelsR4.Patient` resource to identify the bundle and provide a human-readable name.
public struct FHIRBundleSelector: View {
    private struct PatientIdentifiedBundle: Identifiable {
        let id: String
        let bundle: ModelsR4.Bundle
    }
    
    
    private let bundles: [PatientIdentifiedBundle]
    
    @Environment(FHIRStore.self) private var store

    private var selectedBundle: Binding<PatientIdentifiedBundle.ID?> {
        Binding(
            get: {
                guard let patient = store.otherResources.compactMap({ resource -> ModelsR4.Patient? in
                    guard case let .r4(resource) = resource.versionedResource, let loadedPatient = resource as? Patient else {
                        return nil
                    }
                    return loadedPatient
                }).first else {
                    return nil
                }
                
                
                guard let bundle = bundles.first(where: { patient.identifier == $0.bundle.patient?.identifier }) else {
                    return nil
                }
                
                return bundle.id
            },
            set: { newValue in
                guard let newValue, let bundle = bundles.first(where: { $0.id == newValue })?.bundle else {
                    return
                }
                
                store.removeAllResources()
                store.load(bundle: bundle)
            }
        )
    }
    
    
    public var body: some View {
        Picker(
            String(localized: "Select Mock Patient", bundle: .module),
            selection: selectedBundle
        ) {
            ForEach(bundles) { bundle in
                Text(bundle.bundle.patientName)
                    .tag(bundle.id as String?)
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
