//
//  LoginPage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import XCTest

final class LoginPage: BasePage {
    var registerButton: XCUIElement { app.buttons[AccessibilityID.Login.registerButton] }
    var simulateLoginButton: XCUIElement { app.buttons[AccessibilityID.Login.simulateLoginButton] }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(registerButton.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(simulateLoginButton.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    func tapRegister() -> RegisterPage {
        XCTAssertTrue(registerButton.waitForExistence(timeout: 5))
        registerButton.tap()
        return RegisterPage(app: app)
    }

    func tapSimulateLogin() -> CoursesPage {
        XCTAssertTrue(simulateLoginButton.waitForExistence(timeout: 5))
        simulateLoginButton.tap()
        return CoursesPage(app: app)
    }
}
