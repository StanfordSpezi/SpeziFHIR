//
// This source file is part of the Stanford LLM on FHIR project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct PromptSettingsView: View {
    private let promptType: FHIRPrompt
    @State private var prompt: String = ""
    @Binding private var path: NavigationPath
    
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Customize the \(promptType.localizedDescription.lowercased()) prompt.")
                .multilineTextAlignment(.leading)
            TextEditor(text: $prompt)
                .fontDesign(.monospaced)
            Text("Place \(FHIRPrompt.promptPlaceholder) at the position in the prompt where the FHIR resource should be inserted.")
                .multilineTextAlignment(.leading)
                .font(.caption)
            Button(
                action: {
                    promptType.save(prompt: prompt)
                    path.removeLast()
                },
                label: {
                    Text("Save Prompt")
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            )
            .buttonStyle(.borderedProminent)
        }
            .padding()
            .navigationTitle(promptType.localizedDescription)
    }
    
    
    init(promptType: FHIRPrompt, path: Binding<NavigationPath>) {
        self.promptType = promptType
        self._prompt = State(initialValue: promptType.prompt)
        self._path = path
    }
}

struct PromptSettingsView_Previews: PreviewProvider {
    @State private static var path = NavigationPath()
    
    static var previews: some View {
        PromptSettingsView(promptType: FHIRPrompt.summary, path: $path)
    }
}
