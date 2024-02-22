//
// This source file is part of the Stanford LLM on FHIR project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIR
import SpeziLLM
import SpeziLLMOpenAI
import SpeziLocalStorage
import SwiftUI


public class FHIRInterpretationModule: Module, DefaultInitializable {
    public enum Defaults {
        public static var llmSchema: LLMOpenAISchema {
            .init(
                parameters: .init(
                    modelType: .gpt4_turbo_preview,
                    systemPrompt: nil   // No system prompt as this will be determined later by the resource interpreter
                )
            )
        }
    }
    
    
    @Dependency private var localStorage: LocalStorage
    @Dependency private var llmRunner: LLMRunner
    @Dependency private var fhirStore: FHIRStore
    
    @Model private var resourceSummary: FHIRResourceSummary
    @Model private var resourceInterpreter: FHIRResourceInterpreter
    @Model private var multipleResourceInterpreter: FHIRMultipleResourceInterpreter
    
    // TODO: Adjust this to make it configurable after the fact
    // UserDefaults.standard.string(forKey: StorageKeys.openAIModel) ?? StorageKeys.Defaults.openAIModel
    let summaryLLMSchema: any LLMSchema
    let interpretationLLMSchema: any LLMSchema
    let openAIModelType: LLMOpenAIModelType
    
    
    public func configure() {
        resourceSummary = FHIRResourceSummary(
            localStorage: localStorage,
            llmRunner: llmRunner,
            llmSchema: summaryLLMSchema
        )
        
        resourceInterpreter = FHIRResourceInterpreter(
            localStorage: localStorage,
            llmRunner: llmRunner,
            llmSchema: interpretationLLMSchema
        )
        
        multipleResourceInterpreter = FHIRMultipleResourceInterpreter(
            localStorage: localStorage,
            llmRunner: llmRunner,
            llmSchema: LLMOpenAISchema(
                parameters: .init(
                    modelType: openAIModelType,
                    systemPrompt: nil   // No system prompt as this will be determined later by the resource interpreter
                )
            ) {
                // FHIR interpretation function
                FHIRGetResourceLLMFunction(
                    fhirStore: self.fhirStore,
                    resourceSummary: self.resourceSummary,
                    allResourcesFunctionCallIdentifier: self.fhirStore.allResourcesFunctionCallIdentifier
                )
            },
            fhirStore: fhirStore
        )
    }
    
    
    // TODO: The multipleResource LLM is always fixed to OpenAI itself because of the function calls
    // Ensure that passed schema's don't contain a system prompt!
    public init<SummaryLLM: LLMSchema, InterpretationLLM: LLMSchema>(
        summaryLLMSchema: SummaryLLM = Defaults.llmSchema,
        interpretationLLMSchema: InterpretationLLM = Defaults.llmSchema,
        multipleResourceInterpretationOpenAIModel: LLMOpenAIModelType
    ) {
        self.summaryLLMSchema = summaryLLMSchema
        self.interpretationLLMSchema = interpretationLLMSchema
        self.openAIModelType = multipleResourceInterpretationOpenAIModel
    }
    
    
    public required convenience init() {
        self.init(
            summaryLLMSchema: Defaults.llmSchema,
            interpretationLLMSchema: Defaults.llmSchema,
            multipleResourceInterpretationOpenAIModel: .gpt4_turbo_preview
        )
    }
}
