//
//  AuthFlowUITests.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class AuthFlowUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func test_loginScreen_isDisplayedWithExpectedContent() {
        let app = XCUIApplication()
        app.launch()

        let loginPage = LoginPage(app: app)
        loginPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Login.registerButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Login.simulateLoginButton].waitForExistence(timeout: 5))
    }

    func test_tappingRegister_navigatesToRegisterScreen() {
        let app = XCUIApplication()
        app.launch()

        let registerPage = LoginPage(app: app)
            .assertIsDisplayed()
            .tapRegister()

        registerPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Register.backButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Register.simulateRegisterButton].waitForExistence(timeout: 5))
    }

    func test_tappingBackOnRegister_returnsToLoginScreen() {
        let app = XCUIApplication()
        app.launch()

        let loginPage = LoginPage(app: app)
            .assertIsDisplayed()
            .tapRegister()
            .assertIsDisplayed()
            .tapBack()

        loginPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Login.registerButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Login.simulateLoginButton].waitForExistence(timeout: 5))
    }

    func test_simulateLogin_navigatesToCoursesScreen() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .assertIsDisplayed()
            .tapSimulateLogin()

        coursesPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.addButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.menuButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.logoutButton].waitForExistence(timeout: 5))
    }

    func test_simulateRegister_navigatesToCoursesScreen() {
        let app = XCUIApplication()
        app.launch()

        let coursesPage = LoginPage(app: app)
            .assertIsDisplayed()
            .tapRegister()
            .assertIsDisplayed()
            .tapSimulateRegister()

        coursesPage.assertIsDisplayed()

        XCTAssertTrue(app.buttons[AccessibilityID.Courses.addButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.menuButton].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[AccessibilityID.Courses.logoutButton].waitForExistence(timeout: 5))
    }
}
