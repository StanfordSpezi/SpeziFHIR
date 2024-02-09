//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziChat
import SpeziFHIR
import SpeziLLM
import SpeziLLMOpenAI
import SpeziLocalStorage


actor FHIRResourceProcessor<Content: Codable & LosslessStringConvertible> {
    typealias Results = [FHIRResource.ID: Content]
    
    
    private let localStorage: LocalStorage
    private let llmRunner: LLMRunner
    private let llmSchema: any LLMSchema
    private let storageKey: String
    private let prompt: FHIRPrompt
    
    
    var results: Results = [:] {
        didSet {
            do {
                try localStorage.store(results, storageKey: storageKey)
            } catch {
                print(error)
            }
        }
    }
    
    
    init(
        localStorage: LocalStorage,
        llmRunner: LLMRunner,
        llmSchema: any LLMSchema,
        storageKey: String,
        prompt: FHIRPrompt
    ) {
        self.localStorage = localStorage
        self.llmRunner = llmRunner
        self.llmSchema = llmSchema
        self.storageKey = storageKey
        self.prompt = prompt
        self.results = (try? localStorage.read(storageKey: storageKey)) ?? [:]
    }
    
    
    @discardableResult
    func process(resource: FHIRResource, forceReload: Bool = false) async throws -> Content {
        if let result = results[resource.id], !result.description.isEmpty, !forceReload {
            return result
        }
        
        let llm = await llmRunner(with: llmSchema)
        
        await MainActor.run {
            llm.context.append(systemMessage: prompt.prompt(withFHIRResource: resource.jsonDescription))
        }
        
        let chatStreamResults = try await llm.generate()
        var result = ""
        
        for try await chatStreamResult in chatStreamResults {
            result.append(chatStreamResult)
        }
        
        guard let content = Content(result) else {
            throw FHIRResourceProcessorError.notParsableAsAString
        }
        
        results[resource.id] = content
        return content
    }
}
