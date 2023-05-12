//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@main
struct UITestsApp: App {
    enum Tests: String, CaseIterable, Identifiable {
        case fhirMockDataStorageProvider = "FHIRMockDataStorageProvider"
        
        
        var id: RawValue {
            self.rawValue
        }
        
        @MainActor
        @ViewBuilder
        func view(withNavigationPath path: Binding<NavigationPath>) -> some View {
            switch self {
            case .fhirMockDataStorageProvider:
                FHIRMockDataStorageProviderTestsView()
            }
        }
    }
    
    
    @UIApplicationDelegateAdaptor(TestAppDelegate.self) var appDelegate
    @State private var path = NavigationPath()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                List(Tests.allCases) { test in
                    NavigationLink(test.rawValue, value: test)
                }
                    .navigationDestination(for: Tests.self) { test in
                        test.view(withNavigationPath: $path)
                    }
                    .navigationTitle("UITest")
            }
                .spezi(appDelegate)
        }
    }
}
