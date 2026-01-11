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
                    numResourcesRow("Allergy Intolerances", \.allergyIntolerances)
                    numResourcesRow("Conditions", \.conditions)
                    numResourcesRow("Diagnostics", \.diagnostics)
                    numResourcesRow("Documents", \.documents)
                    numResourcesRow("Encounters", \.encounters)
                    numResourcesRow("Immunizations", \.immunizations)
                    numResourcesRow("Medications", \.medications)
                    numResourcesRow("Observations", \.observations)
                    numResourcesRow("Procedures", \.procedures)
                    numResourcesRow("Other Resources", \.otherResources)
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
                        let resource = ModelsR4.Account(
                            id: "\(additionalFHIRResourceId):\(UUID().uuidString)".asFHIRStringPrimitive(),
                            status: .init()
                        )
                        fhirStore.insert(FHIRResource(resource: resource, displayName: "Random Account FHIR Resource"))
                    } label: {
                        Label("Add", systemImage: "doc.badge.plus")
                            .accessibilityLabel("Add FHIR Resource")
                    }
                }
                ToolbarItem {
                    Button {
                        fhirStore.removeAllResources {
                            ($0.fhirId ?? "").starts(with: additionalFHIRResourceId)
                        }
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
            await standard.fetchRecordsFromHealthKit()
        }
    }
    
    private func numResourcesRow(
        _ title: String,
        _ resourcesKeyPath: KeyPath<FHIRStore, some Collection<FHIRResource>>
    ) -> some View {
        LabeledContent(title, value: fhirStore[keyPath: resourcesKeyPath].count, format: .number)
    }
}
