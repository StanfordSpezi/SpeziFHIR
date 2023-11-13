//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Observation
import SpeziFHIR
import SpeziLocalStorage
import SpeziOpenAI


/// Responsible for summarizing FHIR resources.
@Observable
public class FHIRResourceSummary {
    private let resourceProcesser: FHIRResourceProcesser
    
    
    init(localStorage: LocalStorage, openAIComponent: OpenAIModel) {
        self.resourceProcesser = FHIRResourceProcesser(
            localStorage: localStorage,
            openAIComponent: openAIComponent,
            storageKey: "FHIRResourceSummary.Summaries",
            prompt: FHIRPrompt.summary
        )
    }
    
    
    /// Summarizes a given FHIR resource. Returns a human-readable summary.
    ///
    /// - Parameters:
    ///   - resource: The `FHIRResource` to be summarized.
    ///   - forceReload: A boolean value that indicates whether to reload and reprocess the resource.
    /// - Returns: An asynchronous `String` representing the summarization of the resource.
    @discardableResult
    public func summarize(resource: FHIRResource, forceReload: Bool = false) async throws -> String {
        try await resourceProcesser.process(resource: resource, forceReload: forceReload)
    }
}


extension FHIRPrompt {
    static let summary: FHIRPrompt = {
        FHIRPrompt(
            storageKey: "prompt.summary",
            localizedDescription: String(localized: "Summary Prompt"),
            defaultPrompt: String(localized: "FHIR_RESOURCE_SUMMARY_PROMPT \(FHIRPrompt.promptPlaceholder) \(Locale.preferredLanguages[0])")
        )
    }()
}
