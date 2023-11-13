//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


extension FHIRResource {
    public func matchesDisplayName(with searchText: String) -> Bool {
        let formattedSearchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return displayName.lowercased().contains(formattedSearchText)
    }
}


extension Array where Element == FHIRResource {
    public func filterByDisplayName(with searchText: String) -> [FHIRResource] {
        if searchText.isEmpty {
            return self
        }

        return filter { resource in
            resource.matchesDisplayName(with: searchText)
        }
    }
}
