//
//  CoursesPage.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import XCTest

final class CoursesPage: BasePage {
    var addButton: XCUIElement { app.buttons[AccessibilityID.Courses.addButton] }
    var menuButton: XCUIElement { app.buttons[AccessibilityID.Courses.menuButton] }

    var createCourseButton: XCUIElement { app.buttons[AccessibilityID.Courses.createCourseButton] }
    var joinCourseButton: XCUIElement { app.buttons[AccessibilityID.Courses.joinCourseButton] }

    var sideMenu: XCUIElement { app.otherElements[AccessibilityID.Courses.sideMenu] }
    var sideMenuCloseButton: XCUIElement { app.buttons[AccessibilityID.Courses.sideMenuCloseButton] }
    var sideMenuLogoutButton: XCUIElement { app.buttons[AccessibilityID.Courses.sideMenuLogoutButton] }

    var firstCourseCard: XCUIElement {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "courses.courseCard.")
        return app.otherElements.matching(predicate).firstMatch
    }

    @discardableResult
    func assertIsDisplayed(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), file: file, line: line)
        XCTAssertTrue(menuButton.waitForExistence(timeout: 5), file: file, line: line)
        return self
    }

    @discardableResult
    func tapAddButton() -> Self {
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        return self
    }

    func tapCreateCourse() -> CreateCoursePage {
        XCTAssertTrue(createCourseButton.waitForExistence(timeout: 5))
        createCourseButton.tap()
        return CreateCoursePage(app: app)
    }

    func tapJoinCourse() -> JoinCoursePage {
        XCTAssertTrue(joinCourseButton.waitForExistence(timeout: 5))
        joinCourseButton.tap()
        return JoinCoursePage(app: app)
    }

    @discardableResult
    func openSideMenu() -> Self {
        XCTAssertTrue(menuButton.waitForExistence(timeout: 5))
        menuButton.tap()
        XCTAssertTrue(sideMenu.waitForExistence(timeout: 5))
        return self
    }

    @discardableResult
    func closeSideMenu() -> Self {
        XCTAssertTrue(sideMenuCloseButton.waitForExistence(timeout: 5))
        sideMenuCloseButton.tap()
        return self
    }

    func tapLogout() -> LoginPage {
        XCTAssertTrue(sideMenuLogoutButton.waitForExistence(timeout: 5))
        sideMenuLogoutButton.tap()
        return LoginPage(app: app)
    }

    func tapFirstCourse() -> CoursePage {
        XCTAssertTrue(firstCourseCard.waitForExistence(timeout: 5))
        firstCourseCard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        return CoursePage(app: app)
    }
}
