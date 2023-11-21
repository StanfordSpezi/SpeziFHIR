//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class SpeziFHIRTests: XCTestCase {
    func testSpeziFHIR() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.staticTexts["Allergy Intolerances: 0"].waitForExistence(timeout: 2))
    }
}
