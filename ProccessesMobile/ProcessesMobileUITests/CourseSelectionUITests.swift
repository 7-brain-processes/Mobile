//
//  CourseSelectionUITests.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest


final class CourseSelectionUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test_tappingCourseCard_opensCourseScreen() {
        let app = XCUIApplication()
        app.launch()

        let coursePage = LoginPage(app: app)
            .tapSimulateLogin()
            .assertIsDisplayed()
            .tapFirstCourse()

        coursePage.assertIsDisplayed()
    }
}
