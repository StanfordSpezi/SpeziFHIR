//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class SpeziFHIRTests: XCTestCase {
    func testMockPatientResources() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.staticTexts["Allergy Intolerances: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Conditions: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Diagnostics: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Documents: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Encounters: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Immunizations: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Medications: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Observations: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Procedures: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Other Resources: 0"].waitForExistence(timeout: 2))

        XCTAssert(app.buttons["Select Mock Patient"].waitForExistence(timeout: 2))
        app.buttons["Select Mock Patient"].tap()

        XCTAssert(app.buttons["Jamison785 Denesik803"].waitForExistence(timeout: 20))
        app.buttons["Jamison785 Denesik803"].tap()
        
        app.navigationBars["Select Mock Patient"].buttons["Dismiss"].tap()
        
        XCTAssert(app.staticTexts["Allergy Intolerances: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Conditions: 70"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Diagnostics: 205"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Documents: 82"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Encounters: 82"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Immunizations: 12"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Medications: 31"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Observations: 769"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Procedures: 106"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Other Resources: 220"].waitForExistence(timeout: 2))

        XCTAssert(app.buttons["Select Mock Patient"].waitForExistence(timeout: 2))
        app.buttons["Select Mock Patient"].tap()

        XCTAssert(app.buttons["Maye976 Dickinson688"].waitForExistence(timeout: 20))
        app.buttons["Maye976 Dickinson688"].tap()
        
        app.navigationBars["Select Mock Patient"].buttons["Dismiss"].tap()
        
        XCTAssert(app.staticTexts["Allergy Intolerances: 0"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Conditions: 37"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Diagnostics: 113"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Documents: 86"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Encounters: 86"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Immunizations: 11"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Medications: 55"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Observations: 169"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Procedures: 225"].waitForExistence(timeout: 2))
        XCTAssert(app.staticTexts["Other Resources: 236"].waitForExistence(timeout: 2))
    }

    func testAddingAndRemovingResources() throws {
        let app = XCUIApplication()
        app.launch()

        // Add 5 resources
        for resourceCount in 0..<5 {
            XCTAssert(app.staticTexts["Other Resources: \(resourceCount)"].waitForExistence(timeout: 2))

            XCTAssert(app.buttons["Add FHIR Resource"].waitForExistence(timeout: 2))
            app.buttons["Add FHIR Resource"].tap()
        }

        // Remove added resources
        XCTAssert(app.buttons["Remove FHIR Resource"].waitForExistence(timeout: 2))
        app.buttons["Remove FHIR Resource"].tap()

        XCTAssert(app.staticTexts["Other Resources: 0"].waitForExistence(timeout: 2))

        // Try removing a second time
        XCTAssert(app.buttons["Remove FHIR Resource"].waitForExistence(timeout: 2))
        app.buttons["Remove FHIR Resource"].tap()

        XCTAssert(app.staticTexts["Other Resources: 0"].waitForExistence(timeout: 2))

        // Select mock patient
        XCTAssert(app.buttons["Select Mock Patient"].waitForExistence(timeout: 2))
        app.buttons["Select Mock Patient"].tap()

        XCTAssert(app.buttons["Jamison785 Denesik803"].waitForExistence(timeout: 20))
        app.buttons["Jamison785 Denesik803"].tap()

        app.navigationBars["Select Mock Patient"].buttons["Dismiss"].tap()

        XCTAssert(app.staticTexts["Other Resources: 220"].waitForExistence(timeout: 2))

        // Add resource to mock patient
        XCTAssert(app.buttons["Add FHIR Resource"].waitForExistence(timeout: 2))
        app.buttons["Add FHIR Resource"].tap()

        XCTAssert(app.staticTexts["Other Resources: 221"].waitForExistence(timeout: 2))

        // Remove resource from mock patient
        XCTAssert(app.buttons["Remove FHIR Resource"].waitForExistence(timeout: 2))
        app.buttons["Remove FHIR Resource"].tap()

        XCTAssert(app.staticTexts["Other Resources: 220"].waitForExistence(timeout: 2))

        // Try removing a second time
        XCTAssert(app.buttons["Remove FHIR Resource"].waitForExistence(timeout: 2))
        app.buttons["Remove FHIR Resource"].tap()

        XCTAssert(app.staticTexts["Other Resources: 220"].waitForExistence(timeout: 2))
    }
}
