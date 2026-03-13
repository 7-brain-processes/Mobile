//
//  CoursePage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class CoursePage: BasePage {
    var title: XCUIElement { app.staticTexts[AccessibilityID.Course.title] }
    var teacherBadge: XCUIElement { app.staticTexts[AccessibilityID.Course.teacherBadge] }
    var studentBadge: XCUIElement { app.staticTexts[AccessibilityID.Course.studentBadge] }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(title.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(
            teacherBadge.waitForExistence(timeout: 2) || studentBadge.waitForExistence(timeout: 2),
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    func assertTeacherVisible(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(teacherBadge.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    @discardableResult
    func assertStudentVisible(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(studentBadge.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }
}
