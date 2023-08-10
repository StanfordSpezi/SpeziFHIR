//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


final class FHIRMockWebServiceTests: XCTestCase {
    func testFHIRMockWebServiceTests() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["FHIRMockWebService"].tap()
        
        XCTAssert(app.buttons["Mock Requests"].waitForExistence(timeout: 2))
        app.buttons["Mock Requests"].tap()
        
        XCTAssert(app.images["Previous Page"].waitForExistence(timeout: 2))
        app.images["Previous Page"].tap()
        
        XCTAssert(app.staticTexts["/Test/"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["{\"test\": \"test\"}"].waitForExistence(timeout: 2))
        
        app.navigationBars.buttons["Mock Upload"].tap()
        
        XCTAssert(app.images["Trash"].waitForExistence(timeout: 2))
        app.images["Trash"].tap()
        
        XCTAssert(app.staticTexts["/TestRemoval/"].waitForExistence(timeout: 2))
    }
}
