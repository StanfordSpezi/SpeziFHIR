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
class FHIRResourceProcesser<Content: Codable & LosslessStringConvertible> {
    typealias Results = [FHIRResource.ID: Content]
    
    
    private let localStorage: LocalStorage
    private let openAIModel: OpenAIModel
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
        openAIModel: OpenAIModel,
        storageKey: String,
        prompt: FHIRPrompt
    ) {
        self.localStorage = localStorage
        self.openAIModel = openAIModel
        self.storageKey = storageKey
        self.prompt = prompt
        self.results = (try? localStorage.read(storageKey: storageKey)) ?? [:]
    }
    
    
    @discardableResult
    func process(resource: FHIRResource, forceReload: Bool = false) async throws -> Content {
        if let result = results[resource.id], !result.description.isEmpty, !forceReload {
            return result
        }
        
        let chatStreamResults = try await openAIModel.queryAPI(withChat: [systemPrompt(forResource: resource)])
        var result = ""
        
        for try await chatStreamResult in chatStreamResults {
            for choice in chatStreamResult.choices {
                result.append(choice.delta.content ?? "")
            }
        }
        
        guard let content = Content(result) else {
            throw FHIRResourceProcesserError.notParsableAsAString
        }
        
        results[resource.id] = content
        return content
    }
    
    private func systemPrompt(forResource resource: FHIRResource) -> Chat {
        Chat(
            role: .system,
            content: prompt.prompt(withFHIRResource: resource.jsonDescription)
        )
    }
}
