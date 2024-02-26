//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIRLLM
import SpeziLLM
import SpeziLocalStorage


class ExampleModule: Module, @unchecked Sendable {
    @Dependency private var localStorage: LocalStorage
    @Dependency private var llmRunner: LLMRunner
    
    @Model private var resourceSummary: FHIRResourceSummary
    @Model private var resourceInterpreter: FHIRResourceInterpreter
    
    let llmSchema = LLMMockSchema()
    
    func configure() {
        resourceSummary = FHIRResourceSummary(
            localStorage: localStorage,
            llmRunner: llmRunner,
            llmSchema: llmSchema
        )
        resourceInterpreter = FHIRResourceInterpreter(
            localStorage: localStorage,
            llmRunner: llmRunner,
            llmSchema: llmSchema
        )
    }
}
