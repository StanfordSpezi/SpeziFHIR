//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Observation
import SpeziFHIR
import SpeziLocalStorage
import SpeziOpenAI


@Observable
class FHIRResourceProcesser {
    typealias Results = [FHIRResource.ID: String]
    
    
    private let localStorage: LocalStorage
    private let openAIComponent: OpenAIModel
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
        openAIComponent: OpenAIModel,
        storageKey: String,
        prompt: FHIRPrompt
    ) {
        self.localStorage = localStorage
        self.openAIComponent = openAIComponent
        self.storageKey = storageKey
        self.prompt = prompt
        self.results = (try? localStorage.read(storageKey: storageKey)) ?? [:]
    }
    
    
    @discardableResult
    func process(resource: FHIRResource, forceReload: Bool = false) async throws -> String {
        if let result = results[resource.id], !result.isEmpty, !forceReload {
            return result
        }
        
        let chatStreamResults = try await openAIComponent.queryAPI(withChat: [systemPrompt(forResource: resource)])
        var result = ""
        
        for try await chatStreamResult in chatStreamResults {
            for choice in chatStreamResult.choices {
                result.append(choice.delta.content ?? "")
            }
        }
        
        results[resource.id] = result
        return result
    }
    
    private func systemPrompt(forResource resource: FHIRResource) -> Chat {
        Chat(
            role: .system,
            content: prompt.prompt.replacingOccurrences(of: FHIRPrompt.promptPlaceholder, with: resource.jsonDescription)
        )
    }
}
