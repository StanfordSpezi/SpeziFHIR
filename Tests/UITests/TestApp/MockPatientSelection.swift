//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct MockPatientSelection: View {
    var body: some View {
        NavigationStack {
            List {
                FHIRMockPatientSelection()
            }
            .toolbar {
                DismissButton()
//                    .accessibilityLabel("Close Mock Patient Selection")
            }
            .navigationTitle("Select Mock Patient")
        }
    }
}
