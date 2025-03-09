//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SpeziFHIR
import SpeziHealthKit
import SpeziViews
import SwiftUI


struct ContentView: View {
    @Environment(HealthKit.self) private var healthKit
    @Environment(FHIRStore.self) private var fhirStore
    @Environment(TestingStandard.self) private var standard
    @State private var presentPatientSelection = false
    @State private var viewState: ViewState = .idle

    private let additionalFHIRResourceId = "SuperUniqueFHIRResourceIdentifier"

    
    var body: some View {
        NavigationStack {   // swiftlint:disable:this closure_body_length
            List {
                Section {
                    Text("Allergy Intolerances: \(fhirStore.allergyIntolerances.count)")
                    Text("Conditions: \(fhirStore.conditions.count)")
                    Text("Diagnostics: \(fhirStore.diagnostics.count)")
                    Text("Documents: \(fhirStore.documents.count)")
                    Text("Encounters: \(fhirStore.encounters.count)")
                    Text("Immunizations: \(fhirStore.immunizations.count)")
                    Text("Medications: \(fhirStore.medications.count)")
                    Text("Observations: \(fhirStore.observations.count)")
                    Text("Procedures: \(fhirStore.procedures.count)")
                    Text("Other Resources: \(fhirStore.otherResources.count)")
                }
                Section {
                    presentPatientSelectionButton
                    collectFromHealthKitButton
                }
            }
                .viewStateAlert(state: $viewState)
                .sheet(isPresented: $presentPatientSelection) {
                    MockPatientSelection(presentPatientSelection: $presentPatientSelection)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            fhirStore.insert(
                                resource: .init(
                                    resource: ModelsR4.Account(id: .init(stringLiteral: additionalFHIRResourceId), status: .init()),
                                    displayName: "Random Account FHIR Resource"
                                )
                            )
                        } label: {
                            Label("Add", systemImage: "doc.badge.plus")
                                .accessibilityLabel("Add FHIR Resource")
                        }
                    }
                    ToolbarItem {
                        Button {
                            fhirStore.remove(resource: additionalFHIRResourceId)
                        } label: {
                            Label("Remove", systemImage: "folder.badge.minus")
                                .accessibilityLabel("Remove FHIR Resource")
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
    
    @ViewBuilder private var collectFromHealthKitButton: some View {
        AsyncButton("Load HealthKit Clinical Records", state: $viewState) {
            try await healthKit.askForAuthorization()
            await standard.loadHealthKitResources()
        }
    }
}
