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
                    ToolbarItem {
                        Button(
                            action: {
                                presentPatientSelection.toggle()
                            },
                            label: {
                                Text("Dismiss")
                            }
                        )
                    }
                }
                .navigationTitle("Select Mock Patient")
        }
    }
}
