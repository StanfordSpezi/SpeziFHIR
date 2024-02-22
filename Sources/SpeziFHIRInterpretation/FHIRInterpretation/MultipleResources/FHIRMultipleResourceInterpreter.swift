//
// This source file is part of the Stanford LLM on FHIR project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import os
import Spezi
import SpeziChat
import SpeziFHIR
import SpeziLLM
import SpeziLLMOpenAI
import SpeziLocalStorage
import SpeziViews
import SwiftUI


private enum FHIRMultipleResourceInterpreterConstants {
    static let chat = "FHIRMultipleResourceInterpreter.chat"
}


@Observable
class FHIRMultipleResourceInterpreter {
    static let logger = Logger(subsystem: "edu.stanford.spezi.fhir", category: "SpeziFHIRInterpretation")
    
    private let localStorage: LocalStorage
    private let llmRunner: LLMRunner
    private let llmSchema: any LLMSchema
    private let fhirStore: FHIRStore
    
    var llm: (any LLMSession)?
    
    
    required init(
        localStorage: LocalStorage,
        llmRunner: LLMRunner,
        llmSchema: any LLMSchema,
        fhirStore: FHIRStore
    ) {
        self.localStorage = localStorage
        self.llmRunner = llmRunner
        self.llmSchema = llmSchema
        self.fhirStore = fhirStore
    }
    
    
    @MainActor
    func resetChat() {
        var context = Chat()
        context.append(systemMessage: FHIRPrompt.interpretMultipleResources.prompt)
        if let patient = fhirStore.patient {
            context.append(systemMessage: patient.jsonDescription)
        }
        
        llm?.context = context
    }
    
    @MainActor
    func prepareLLM() async {
        guard llm == nil else {
            return
        }
        
        var llm = await llmRunner(with: llmSchema)
        // Read initial conversation from storage
        if let storedContext: Chat = try? localStorage.read(storageKey: FHIRMultipleResourceInterpreterConstants.chat) {
            llm.context = storedContext
        } else {
            llm.context.append(systemMessage: FHIRPrompt.interpretMultipleResources.prompt)
            if let patient = fhirStore.patient {
                llm.context.append(systemMessage: patient.jsonDescription)
            }
        }

        self.llm = llm
    }

    @MainActor
    func queryLLM() {
        guard let llm,
              llm.context.last?.role == .user || !(llm.context.contains(where: { $0.role == .assistant }) ?? false) else {
            return
        }
        
        Task {
            Self.logger.debug("The Multiple Resource Interpreter has access to \(self.fhirStore.llmRelevantResources.count) resources.")
            
            guard let stream = try? await llm.generate() else {
                return
            }
            
            for try await token in stream {
                llm.context.append(assistantOutput: token)
            }
            
            // Store conversation to storage
            try localStorage.store(llm.context, storageKey: FHIRMultipleResourceInterpreterConstants.chat)
        }
    }
}


extension FHIRPrompt {
    /// Prompt used to interpret multiple FHIR resources
    ///
    /// This prompt is used by the ``FHIRMultipleResourceInterpreter``.
    public static let interpretMultipleResources: FHIRPrompt = {
        FHIRPrompt(
            storageKey: "prompt.interpretMultipleResources",
            localizedDescription: String(
                localized: "Interpretation Prompt",
                comment: "Title of the multiple resources interpretation prompt."
            ),
            defaultPrompt: String(
                localized: "Interpretation Prompt Content",
                comment: "Content of the multiple resources interpretation prompt."
            )
        )
    }()
}
