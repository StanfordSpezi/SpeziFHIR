//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct RequestHeader: View {
    let request: Request
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                switch request.type {
                case .add:
                    Image(systemName: "arrow.up.doc.fill")
                        .foregroundColor(.green)
                case .delete:
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
                Text("/\(request.path)/")
            }
                .font(.title3)
                .bold()
                .padding(.bottom, 12)
            Text("On \(format(request.date))")
                .font(.subheadline)
        }
    }
    
    
    private func format(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
}


#if DEBUG
struct RequestHeader_Previews: PreviewProvider {
    static var previews: some View {
        RequestHeader(
            request: Request(
                type: .add,
                path: "A Path"
            )
        )
    }
}
#endif
