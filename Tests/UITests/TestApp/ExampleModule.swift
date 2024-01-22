//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIRInterpretation
import SpeziLLM
import SpeziLocalStorage


class ExampleModule: Module {
    private let llm = LLMMock()
    
    
    @Dependency private var localStorage: LocalStorage
    @Dependency private var llmRunner: LLMRunner
    
    @Model private var resourceSummary: FHIRResourceSummary
    @Model private var resourceInterpreter: FHIRResourceInterpreter
    
    
    func configure() {
        resourceSummary = FHIRResourceSummary(localStorage: localStorage, llmRunner: llmRunner, llm: llm)
        resourceInterpreter = FHIRResourceInterpreter(localStorage: localStorage, llmRunner: llmRunner, llm: llm)
    }
}
