//
// This source file is part of the Stanford LLM on FHIR project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Handle dynamic, localized LLM prompts for FHIR resources.
public struct FHIRPrompt {
    /// Placeholder for dynamic content in prompts.
    public static let promptPlaceholder = "%@"
    
    /// The key used for storing and retrieving the prompt.
    public let storageKey: String
    /// A human-readable description of the prompt, localized as needed.
    public let localizedDescription: String
    /// The default prompt text to be used if no custom prompt is set.
    public let defaultPrompt: String

    /// The current prompt, either from UserDefaults or the default, appended with a localized message that adapts to the user's language settings.
    public var prompt: String {
        var prompt = UserDefaults.standard.string(forKey: storageKey) ?? defaultPrompt
        
        prompt += String(
            localized:
            """
            Chat with the user in the same language they chat in.
            Chat with the user in \(Locale.preferredLanguages[0])
            """,
            comment: "The passed in string is the current locale of the device as a IETF BCP 47 language tag."
        )
        
        return prompt
    }
    
    
    /// - Parameters:
    ///   - storageKey: The key used for storing and retrieving the prompt.
    ///   - localizedDescription: A human-readable description of the prompt, localized as needed.
    ///   - defaultPrompt: The default prompt text to be used if no custom prompt is set.
    public init(
        storageKey: String,
        localizedDescription: String,
        defaultPrompt: String
    ) {
        self.storageKey = storageKey
        self.localizedDescription = localizedDescription
        self.defaultPrompt = defaultPrompt
    }
    
    
    /// Saves a new version of the propmpt.
    /// - Parameter prompt: The new prompt.
    public func save(prompt: String) {
        UserDefaults.standard.set(prompt, forKey: storageKey)
    }
}
