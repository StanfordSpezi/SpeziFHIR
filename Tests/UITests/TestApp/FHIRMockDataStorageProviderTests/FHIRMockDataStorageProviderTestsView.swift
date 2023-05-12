//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziFHIR
import SpeziFHIRMockDataStorageProvider
import SwiftUI


struct FHIRMockDataStorageProviderTestsView: View {
    @EnvironmentObject var fhirStandard: FHIR
    
    
    var body: some View {
        MockUploadList()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Inject Observation") {
                        injectNewObservations()
                    }
                }
            }
    }
    
    
    private func injectNewObservations() {
        let observations = [
            Observation(
                code: .init(),
                id: UUID().uuidString.asFHIRStringPrimitive(),
                status: FHIRPrimitive(.final)
            )
        ]
        
        _Concurrency.Task {
            await fhirStandard.registerDataSource(
                AsyncStream { continuation in
                    for observation in observations {
                        continuation.yield(.addition(observation))
                    }
                }
            )
        }
    }
}


#if DEBUG
struct FHIRMockDataStorageProviderTestsView_Previews: PreviewProvider {
    static var previews: some View {
        FHIRMockDataStorageProviderTestsView()
    }
}
#endif
