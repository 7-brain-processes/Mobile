//
//  RegisterPage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import XCTest

final class RegisterPage: BasePage {
    var backButton: XCUIElement { app.buttons[AccessibilityID.Register.backButton] }
    var simulateRegisterButton: XCUIElement { app.buttons[AccessibilityID.Register.simulateRegisterButton] }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(simulateRegisterButton.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    func tapBack() -> LoginPage {
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        return LoginPage(app: app)
    }

    func tapSimulateRegister() -> CoursesPage {
        XCTAssertTrue(simulateRegisterButton.waitForExistence(timeout: 5))
        simulateRegisterButton.tap()
        return CoursesPage(app: app)
    }
}
