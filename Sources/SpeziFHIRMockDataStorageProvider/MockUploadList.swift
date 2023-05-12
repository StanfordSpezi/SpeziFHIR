//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Displays the recoded uploads collected by the ``MockDataStorageProvider``.
public struct MockUploadList: View {
    @EnvironmentObject var mockDataStorageProvider: MockDataStorageProvider
    
    
    public var body: some View {
        Group {
            if mockDataStorageProvider.mockUploads.isEmpty {
                VStack(spacing: 32) {
                    Image(systemName: "server.rack")
                        .font(.system(size: 100))
                    Text(String(localized: "MOCK_UPLOAD_LIST_PLACEHOLDER", bundle: .module))
                        .multilineTextAlignment(.center)
                }
                    .padding(32)
            } else {
                List(mockDataStorageProvider.mockUploads) { mockUpload in
                    NavigationLink(value: mockUpload) {
                        MockUploadHeader(mockUpload: mockUpload)
                    }
                }
            }
        }
            .navigationDestination(for: MockUpload.self) { mockUpload in
                MockUploadDetailView(mockUpload: mockUpload)
            }
            .navigationTitle(String(localized: "MOCK_UPLOAD_LIST_TITLE", bundle: .module))
    }
    
    
    public init() {}
    
    
    private func format(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
}


#if DEBUG
struct MockUploadsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MockUploadList()
                .environmentObject(MockDataStorageProvider())
        }
    }
}
#endif
