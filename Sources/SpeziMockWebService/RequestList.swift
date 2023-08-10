//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Displays the recoded uploads collected by the ``MockWebService``.
public struct RequestList: View {
    @EnvironmentObject var webService: MockWebService
    
    
    public var body: some View {
        Group {
            if webService.requests.isEmpty {
                VStack(spacing: 32) {
                    Image(systemName: "server.rack")
                        .font(.system(size: 100))
                    Text(String(localized: "MOCK_UPLOAD_LIST_PLACEHOLDER", bundle: .module))
                        .multilineTextAlignment(.center)
                }
                    .padding(32)
            } else {
                List(webService.requests) { request in
                    NavigationLink(value: request) {
                        RequestHeader(request: request)
                    }
                }
            }
        }
            .navigationDestination(for: Request.self) { request in
                RequestDetailView(request: request)
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
struct WebServicesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RequestList()
                .environmentObject(MockWebService())
        }
    }
}
#endif
