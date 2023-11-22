//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIR
import SwiftUI


struct ContentView: View {
    @Environment(FHIRStore.self) var fhirStore
    @State var presentPatientSelection = false
    @State var presentPromptSettings = false
    
    
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
                    Text("Other Resources: \(fhirStore.otherResources.count)")
                    Text("Procedures: \(fhirStore.procedures.count)")
                }
                Section {
                    presentPatientSelectionButton
                }
            }
                .sheet(isPresented: $presentPatientSelection) {
                    MockPatientSelection(presentPatientSelection: $presentPatientSelection)
                }
                .sheet(isPresented: $presentPromptSettings) {
                    PromptSettings(presentPromptSettings: $presentPromptSettings)
                }
                .toolbar {
                    ToolbarItem {
                        presentPromptSettingsButton
                    }
                }
        }
    }
    
    
    @ViewBuilder private var presentPromptSettingsButton: some View {
        Button(
            action: {
                presentPromptSettings.toggle()
            },
            label: {
                Image(systemName: "gear")
                    .accessibilityLabel(Text("Settings"))
            }
        )
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
