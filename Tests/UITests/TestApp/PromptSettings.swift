//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIRInterpretation
import SwiftUI


struct PromptSettings: View {
    @Binding var presentPromptSettings: Bool
    @State var prompt: FHIRPrompt?
    
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(value: FHIRPrompt.summary) {
                    Text(FHIRPrompt.summary.localizedDescription)
                }
                NavigationLink(value: FHIRPrompt.interpretation) {
                    Text(FHIRPrompt.interpretation.localizedDescription)
                }
            }
                .navigationDestination(for: FHIRPrompt.self) { prompt in
                    PromptSettingsView(promptType: prompt) {
                        print("Saved \(prompt.localizedDescription)")
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(
                            action: {
                                presentPromptSettings.toggle()
                            },
                            label: {
                                Text("Dismiss")
                            }
                        )
                    }
                }
                .navigationTitle("Prompt Settings")
        }
    }
}
