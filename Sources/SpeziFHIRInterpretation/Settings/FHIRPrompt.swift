//
// This source file is part of the Stanford LLM on FHIR project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct FHIRPrompt {
    static let promptPlaceholder = "%@"
    
    
    var storageKey: String
    var localizedDescription: String
    var defaultPrompt: String
    
    var prompt: String {
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
    
    func save(prompt: String) {
        UserDefaults.standard.set(prompt, forKey: storageKey)
    }
}
