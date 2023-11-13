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
public struct FHIRMockPatientSelector: View {
    @Environment(FHIRStore.self) var store
    
    let bundles: [ModelsR4.Bundle]
    
    
    @State var selectedBundle: ModelsR4.Bundle? {
        didSet {
            guard let selectedBundle else {
                return
            }
            
            store.removeAllResources()
            store.load(bundle: selectedBundle)
        }
    }
    
    public var body: some View {
        Picker(
            String(localized: "Select Mock Patient", bundle: .module),
            selection: $selectedBundle
        ) {
            ForEach(bundles) { bundle in
                Text(bundle.patientName)
                    .tag(bundle)
            }
        }
            .onAppear {
                let patient = store.otherResources.compactMap { resource -> ModelsR4.Patient? in
                    guard case let .r4(resource) = resource.versionedResource, let loadedPatient = resource as? Patient else {
                        return nil
                    }
                    return loadedPatient
                }.first
                
                
                for bundle in bundles where patient?.identifier == bundle.patient?.identifier {
                    selectedBundle = bundle
                    return
                }
            }
    }
    
    
    public init(bundles: [ModelsR4.Bundle] = Bundle.mockPatients) {
        self.bundles = bundles
    }
}
