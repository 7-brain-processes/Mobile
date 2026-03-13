//
//  JoinCoursePage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class JoinCoursePage: BasePage {
    var codeField: XCUIElement { app.textFields[AccessibilityID.JoinCourse.codeField] }
    var joinButton: XCUIElement { app.buttons[AccessibilityID.JoinCourse.joinButton] }
    var cancelButton: XCUIElement { app.buttons[AccessibilityID.JoinCourse.cancelButton] }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(codeField.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(joinButton.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    @discardableResult
    func enterCode(_ code: String) -> Self {
        XCTAssertTrue(codeField.waitForExistence(timeout: 5))
        codeField.tap()
        codeField.typeText(code)
        return self
    }

    func tapJoin() -> CoursePage {
        XCTAssertTrue(joinButton.waitForExistence(timeout: 5))
        joinButton.tap()
        return CoursePage(app: app)
    }

    func tapCancel() -> CoursesPage {
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()
        return CoursesPage(app: app)
    }
}
