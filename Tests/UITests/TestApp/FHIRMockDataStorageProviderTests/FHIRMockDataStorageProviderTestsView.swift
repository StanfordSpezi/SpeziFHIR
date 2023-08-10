//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIR
import SpeziMockWebService
import SwiftUI


struct FHIRMockWebServiceTestsView: View {
    @EnvironmentObject var webService: MockWebService
    
    
    var body: some View {
        RequestList()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mock Requests") {
                        injectNewObservations()
                    }
                }
            }
    }
    
    
    private func injectNewObservations() {
        Task {
            try await webService.upload(path: "Test", body: #"{"test": "test"}"#)
            try await webService.remove(path: "TestRemoval")
        }
    }
}


#if DEBUG
struct FHIRMockWebServiceTestsView_Previews: PreviewProvider {
    static var previews: some View {
        FHIRMockWebServiceTestsView()
    }
}
#endif
