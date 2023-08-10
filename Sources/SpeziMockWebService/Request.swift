//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct Request: Identifiable, Hashable {
    enum UploadType {
        case add
        case delete
    }
    
    
    let date = Date()
    let type: UploadType
    let path: String
    let body: String?
    
    
    var id: String {
        "\(type): \(path) at \(date.debugDescription)"
    }
    
    
    init(type: UploadType, path: String, body: String? = nil) {
        self.type = type
        self.path = path
        self.body = body
    }
}
