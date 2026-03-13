//
//  CourseScreenUITests.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class CourseScreenUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test_courseScreen_displaysTabs() {
        let app = XCUIApplication()
        app.launch()

        let coursePage = LoginPage(app: app)
            .tapSimulateLogin()
            .assertIsDisplayed()
            .tapFirstCourse()

        coursePage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Course.feedTab].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Course.membersTab].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Course.invitesTab].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Course.infoTab].waitForExistence(timeout: 5))
    }
}
