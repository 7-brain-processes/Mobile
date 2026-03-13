//
//  CoursesFlowUITests.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class CoursesFlowUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test_coursesScreen_isDisplayedWithExpectedContent() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .tapSimulateLogin()

        coursesPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.menuButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.addButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.logoutButton].waitForExistence(timeout: 5))
    }

    func test_tappingAddButton_revealsCreateAndJoinActions() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .tapSimulateLogin()

        coursesPage
            .assertIsDisplayed()
            .tapAddButton()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.createCourseButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.joinCourseButton].waitForExistence(timeout: 5))
    }

    func test_tappingCreateCourse_opensCreateCourseSheet() {
        let app = XCUIApplication()
        app.launch()

        let createCoursePage = LoginPage(app: app)
            .tapSimulateLogin()
            .assertIsDisplayed()
            .tapAddButton()
            .tapCreateCourse()

        createCoursePage.assertIsDisplayed()

        XCTAssertTrue(app.textFields[AccessibilityID.CreateCourse.nameField].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.CreateCourse.finishButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.CreateCourse.cancelButton].waitForExistence(timeout: 5))
    }

    func test_tappingJoinCourse_opensJoinCourseSheet() {
        let app = XCUIApplication()
        app.launch()

        let joinCoursePage = LoginPage(app: app)
            .tapSimulateLogin()
            .assertIsDisplayed()
            .tapAddButton()
            .tapJoinCourse()

        joinCoursePage.assertIsDisplayed()

        XCTAssertTrue(app.textFields[AccessibilityID.JoinCourse.codeField].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.JoinCourse.joinButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.JoinCourse.cancelButton].waitForExistence(timeout: 5))
    }

    func test_finishingCreateCourse_navigatesToCourseScreen() {
            let app = XCUIApplication()
            app.launch()

            let coursePage = LoginPage(app: app)
                .tapSimulateLogin()
                .tapAddButton()
                .tapCreateCourse()
                .assertIsDisplayed()
                .enterCourseName("Algebra")
                .tapFinish()

            coursePage.assertIsDisplayed()
        }

        func test_joiningCourse_navigatesToCourseScreen() {
            let app = XCUIApplication()
            app.launch()

            let coursePage = LoginPage(app: app)
                .tapSimulateLogin()
                .tapAddButton()
                .tapJoinCourse()
                .assertIsDisplayed()
                .enterCode("ABC123")
                .tapJoin()

            coursePage.assertIsDisplayed()
        }

    func test_cancelCreateCourse_returnsToCoursesScreen() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .tapSimulateLogin()
            .tapAddButton()
            .tapCreateCourse()
            .assertIsDisplayed()
            .tapCancel()

        coursesPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.addButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.menuButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.logoutButton].waitForExistence(timeout: 5))
    }

    func test_cancelJoinCourse_returnsToCoursesScreen() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .tapSimulateLogin()
            .tapAddButton()
            .tapJoinCourse()
            .assertIsDisplayed()
            .tapCancel()

        coursesPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.addButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.menuButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.logoutButton].waitForExistence(timeout: 5))
    }

}
