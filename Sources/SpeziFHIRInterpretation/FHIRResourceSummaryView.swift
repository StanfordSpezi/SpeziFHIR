//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIR
import SpeziViews
import SwiftUI


public struct FHIRResourceSummaryView: View {
    @Environment(FHIRResourceSummary.self) private var fhirResourceSummary
    @State private var summary: String?
    @State private var viewState: ViewState = .idle
    
    private let resource: FHIRResource
    
    
    public var body: some View {
        if let summary, !summary.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text(resource.displayName)
                Text(summary)
                    .font(.caption)
            }
                .multilineTextAlignment(.leading)
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text(resource.displayName)
                if viewState == .processing {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.vertical, 6)
                }
            }
                .contextMenu {
                    Button("Load Resource Summary") {
                        Task {
                            viewState = .processing
                            summary = try? await fhirResourceSummary.summarize(resource: resource)
                            viewState = .idle
                        }
                    }
                }
        }
    }
    
    
    public init(resource: FHIRResource) {
        self.resource = resource
    }
}