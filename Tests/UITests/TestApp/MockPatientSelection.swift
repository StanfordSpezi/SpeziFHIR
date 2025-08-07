//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIRMockPatients
import SwiftUI


struct MockPatientSelection: View {
    @Binding var presentPatientSelection: Bool
    
    
    var body: some View {
        NavigationStack {
            List {
                FHIRMockPatientSelection()
            }
                .toolbar {
                    Button {
                        presentPatientSelection.toggle()
                    } label: {
                        Label("Close", systemImage: "xmark")
                            .accessibilityLabel("Close Mock Patient Selection")
                    }
                }
                .navigationTitle("Select Mock Patient")
        }
    }
}
