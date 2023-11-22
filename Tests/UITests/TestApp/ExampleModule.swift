//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIRInterpretation
import SpeziLocalStorage
import class SpeziOpenAI.OpenAIModule
import class SpeziOpenAI.OpenAIModel


class ExampleModule: Module {
    @Dependency private var localStorage: LocalStorage
    @Dependency private var openAI: OpenAIModule
    
    @Model private var resourceSummary: FHIRResourceSummary
    @Model private var resourceInterpreter: FHIRResourceInterpreter
    
    
    func configure() {
        resourceSummary = FHIRResourceSummary(localStorage: localStorage, openAIModel: openAI.model)
        resourceInterpreter = FHIRResourceInterpreter(localStorage: localStorage, openAIModel: openAI.model)
    }
}
