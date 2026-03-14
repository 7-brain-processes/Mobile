//
//  CreateCoursePage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class CreateCoursePage: BasePage {
    var nameField: XCUIElement { app.textFields[AccessibilityID.CreateCourse.nameField] }
    var finishButton: XCUIElement { app.buttons[AccessibilityID.CreateCourse.finishButton] }
    var cancelButton: XCUIElement { app.buttons[AccessibilityID.CreateCourse.cancelButton] }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(finishButton.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    @discardableResult
    func enterCourseName(_ name: String) -> Self {
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText(name)
        return self
    }

    func tapFinish() -> CoursePage {
        XCTAssertTrue(finishButton.waitForExistence(timeout: 5))
        finishButton.tap()
        return CoursePage(app: app)
    }

    func tapCancel() -> CoursesPage {
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()
        return CoursesPage(app: app)
    }
}
