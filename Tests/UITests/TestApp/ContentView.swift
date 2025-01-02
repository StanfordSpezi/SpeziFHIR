//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SpeziFHIR
import SwiftUI


struct ContentView: View {
    @Environment(FHIRStore.self) private var fhirStore
    @State private var presentPatientSelection = false
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Allergy Intolerances: \(fhirStore.allergyIntolerances.count)")
                    Text("Conditions: \(fhirStore.conditions.count)")
                    Text("Diagnostics: \(fhirStore.diagnostics.count)")
                    Text("Encounters: \(fhirStore.encounters.count)")
                    Text("Immunizations: \(fhirStore.immunizations.count)")
                    Text("Medications: \(fhirStore.medications.count)")
                    Text("Observations: \(fhirStore.observations.count)")
                    Text("Procedures: \(fhirStore.procedures.count)")
                    Text("Other Resources: \(fhirStore.otherResources.count)")
                }
                Section {
                    presentPatientSelectionButton
                }
            }
                .sheet(isPresented: $presentPatientSelection) {
                    MockPatientSelection(presentPatientSelection: $presentPatientSelection)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            fhirStore.insert(
                                resource: .init(
                                    resource: ModelsR4.Account(id: "SuperUniqueFHIRResourceIdentifier", status: .init()),
                                    displayName: "Random Account FHIR Resource"
                                )
                            )
                        } label: {
                            Label("Add", systemImage: "doc.badge.plus")
                                .accessibilityLabel("Add FHIR Resource")
                        }
                    }
                }
        }
    }
    
    @ViewBuilder private var presentPatientSelectionButton: some View {
        Button(
            action: {
                presentPatientSelection.toggle()
            },
            label: {
                Text("Select Mock Patient")
            }
        )
    }
}
