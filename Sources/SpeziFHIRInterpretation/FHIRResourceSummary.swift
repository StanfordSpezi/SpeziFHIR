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
    
    
    /// - Parameters:
    ///   - localStorage: Local storage module that needs to be passed to the ``FHIRResourceSummary`` to allow it to cache summaries.
    ///   - openAIModel: OpenAI module that needs to be passed to the ``FHIRResourceSummary`` to allow it to retrieve summaries.
    public init(localStorage: LocalStorage, openAIModel: OpenAIModel) {
        self.resourceProcesser = FHIRResourceProcesser(
            localStorage: localStorage,
            openAIModel: openAIModel,
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
    
    /// Retrieve the cached summary of a given FHIR resource. Returns a human-readable summary or `nil` if it is not present.
    ///
    /// - Parameter resource: The resource where the cached summary should be loaded from.
    /// - Returns: The cached summary. Returns `nil` if the resource is not present.
    public func cachedSummary(forResource resource: FHIRResource) -> String? {
        resourceProcesser.results[resource.id]
    }
}


extension FHIRPrompt {
    /// Prompt used to summarize FHIR resources
    ///
    /// This prompt is used by the ``FHIRResourceSummary``.
    public static let summary: FHIRPrompt = {
        FHIRPrompt(
            storageKey: "prompt.summary",
            localizedDescription: String(
                localized: "Summary Prompt",
                bundle: .module,
                comment: "Title of the summary prompt."
            ),
            defaultPrompt: String(
                localized: "Summary Prompt Content",
                bundle: .module,
                comment: "Content of the summary prompt."
            )
        )
    }()
}
