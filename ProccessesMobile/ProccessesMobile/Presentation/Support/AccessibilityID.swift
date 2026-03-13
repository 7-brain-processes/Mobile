//
//  AccessibilityID.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Foundation

enum AccessibilityID {
    enum Login {
        static let title = "login.title"
        static let loginField = "login.loginField"
        static let passwordField = "login.passwordField"
        static let registerButton = "login.registerButton"
        static let loginButton = "login.loginButton"
        static let errorMessage = "login.errorMessage"
    }

    enum Register {
        static let title = "register.title"
        static let displayedNameField = "register.displayedNameField"
        static let loginField = "register.loginField"
        static let passwordField = "register.passwordField"
        static let backButton = "register.backButton"
        static let registerButton = "register.registerButton"
        static let errorMessage = "register.errorMessage"
    }

    enum Courses {
        static let menuButton = "courses.menuButton"
           static let addButton = "courses.addButton"
           static let createCourseButton = "courses.createCourseButton"
           static let joinCourseButton = "courses.joinCourseButton"

           static let sideMenu = "courses.sideMenu"
           static let sideMenuBackdrop = "courses.sideMenuBackdrop"
           static let sideMenuLogoutButton = "courses.sideMenuLogoutButton"
           static let sideMenuUserAvatar = "courses.sideMenuUserAvatar"
           static let sideMenuUserName = "courses.sideMenuUserName"
           static let sideMenuTeachingSection = "courses.sideMenuTeachingSection"
           static let sideMenuAttendingSection = "courses.sideMenuAttendingSection"

        static func courseCard(_ id: UUID) -> String {
                   "courses.courseCard.\(id.uuidString)"
               }

               static func courseTitle(_ id: UUID) -> String {
                   "courses.courseTitle.\(id.uuidString)"
               }

               static func sideMenuCourse(_ id: UUID) -> String {
                   "courses.sideMenuCourse.\(id.uuidString)"
               }
    }
    enum Feed {
         static let screen = "feed.screen"

         static func postCard(_ id: UUID) -> String {
             "feed.postCard.\(id.uuidString)"
         }

         static func postTitle(_ id: UUID) -> String {
             "feed.postTitle.\(id.uuidString)"
         }

         static func postTypeChip(_ id: UUID) -> String {
             "feed.postTypeChip.\(id.uuidString)"
         }
     }

     enum TaskDetail {
         static let screen = "taskDetail.screen"
         static let title = "taskDetail.title"
         static let author = "taskDetail.author"
         static let date = "taskDetail.date"
         static let deadline = "taskDetail.deadline"
         static let description = "taskDetail.description"
         static let materialsSection = "taskDetail.materialsSection"
     }

     enum MaterialDetail {
         static let screen = "materialDetail.screen"
         static let title = "materialDetail.title"
         static let author = "materialDetail.author"
         static let date = "materialDetail.date"
         static let description = "materialDetail.description"
         static let materialsSection = "materialDetail.materialsSection"
     }

    enum CreateCourse {
        static let title = "createCourse.title"
        static let nameField = "createCourse.nameField"
        static let finishButton = "createCourse.finishButton"
        static let cancelButton = "createCourse.cancelButton"
    }

    enum JoinCourse {
        static let title = "joinCourse.title"
        static let codeField = "joinCourse.codeField"
        static let joinButton = "joinCourse.joinButton"
        static let cancelButton = "joinCourse.cancelButton"
    }

    enum Course {
        static let title = "course.title"
        static let teacherBadge = "course.teacherBadge"
        static let studentBadge = "course.studentBadge"

        static let feedContent = "course.feedContent"
        static let membersContent = "course.membersContent"
        static let invitesContent = "course.invitesContent"
        static let infoContent = "course.infoContent"
        static let feedTab = "course.feedTab"
        static let membersTab = "course.membersTab"
        static let invitesTab = "course.invitesTab"
        static let infoTab = "course.infoTab"
    }
}
