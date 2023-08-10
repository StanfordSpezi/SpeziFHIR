//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct RequestDetailView: View {
    let request: Request
    
    
    var body: some View {
        List {
            Section(String(localized: "MOCK_UPLOAD_DETAIL_HEADER", bundle: .module)) {
                RequestHeader(request: request)
            }
            Section(String(localized: "MOCK_UPLOAD_DETAIL_BODY", bundle: .module)) {
                LazyText(text: request.body ?? "")
            }
        }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
    }
}


#if DEBUG
struct RequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RequestDetailView(
            request: Request(
                type: .add,
                path: "A Path",
                body: "A Body ..."
            )
        )
    }
}
#endif
