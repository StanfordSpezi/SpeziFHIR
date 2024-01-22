//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Observation
import SpeziChat
import SpeziFHIR
import SpeziLocalStorage
import SpeziLLM
import SpeziLLMOpenAI


@Observable
class FHIRResourceProcesser<Content: Codable & LosslessStringConvertible> {
    typealias Results = [FHIRResource.ID: Content]
    
    
    private let localStorage: LocalStorage
    private let llmRunner: LLMRunner
    private let llm: any LLM
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
        llm: any LLM,
        storageKey: String,
        prompt: FHIRPrompt
    ) {
        self.localStorage = localStorage
        self.llmRunner = llmRunner
        self.llm = llm
        self.storageKey = storageKey
        self.prompt = prompt
        self.results = (try? localStorage.read(storageKey: storageKey)) ?? [:]
    }
    
    
    @discardableResult
    func process(resource: FHIRResource, forceReload: Bool = false) async throws -> Content {
        if let result = results[resource.id], !result.description.isEmpty, !forceReload {
            return result
        }
        
        await MainActor.run {
            llm.context.append(.init(role: .system, content: prompt.prompt(withFHIRResource: resource.jsonDescription)))
        }
        
        let chatStreamResults = try await llmRunner(with: llm).generate()
        var result = ""
        
        for try await chatStreamResult in chatStreamResults {
            result.append(chatStreamResult)
        }
        
        guard let content = Content(result) else {
            throw FHIRResourceProcesserError.notParsableAsAString
        }
        
        results[resource.id] = content
        return content
    }
}
