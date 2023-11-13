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


/// Responsible for interpreting FHIR resources.
@Observable
public class FHIRResourceInterpreter {
    private let resourceProcesser: FHIRResourceProcesser
    
    
    init(localStorage: LocalStorage, openAIComponent: OpenAIModel) {
        self.resourceProcesser = FHIRResourceProcesser(
            localStorage: localStorage,
            openAIComponent: openAIComponent,
            storageKey: "FHIRResourceInterpreter.Interpretations",
            prompt: FHIRPrompt.interpretation
        )
    }
    
    
    /// Interprets a given FHIR resource. Returns a human-readable interpretation.
    ///
    /// - Parameters:
    ///   - resource: The `FHIRResource` to be interpreted.
    ///   - forceReload: A boolean value that indicates whether to reload and reprocess the resource.
    /// - Returns: An asynchronous `String` representing the interpretation of the resource.
    @discardableResult
    public func summarize(resource: FHIRResource, forceReload: Bool = false) async throws -> String {
        try await resourceProcesser.process(resource: resource, forceReload: forceReload)
    }
}


extension FHIRPrompt {
    static let interpretation: FHIRPrompt = {
        FHIRPrompt(
            storageKey: "prompt.interpretation",
            localizedDescription: String(localized: "Interpretation Prompt"),
            defaultPrompt: String(localized: "FHIR_RESOURCE_INTERPRETATION_PROMPT \(FHIRPrompt.promptPlaceholder) \(Locale.preferredLanguages[0])")
        )
    }()
}
