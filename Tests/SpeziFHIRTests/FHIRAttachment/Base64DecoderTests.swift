//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Testing
@testable import SpeziFHIR
import Testing
import ModelsR4


@Suite struct Base64DecoderTests {
    private let decoder = DefaultBase64Decoder()

    @Test("Successfully decodes valid base64 string")
    func testValidBase64Decoding() {
        let base64String = "V2VsY29tZSB0byBTcGV6aUZISVI="
        let data = decoder.decode(string: base64String)

        #expect(data != nil)
        if let data = data {
            let decodedString = String(data: data, encoding: .utf8)
            #expect(decodedString == "Welcome to SpeziFHIR")
        }
    }

    @Test("Returns nil for invalid base64 string")
    func testInvalidBase64Decoding() {
        let invalidBase64 = "This is not base64!"
        let data = decoder.decode(string: invalidBase64)

        #expect(data == nil)
    }
}
