//
//  CourseCardItem.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Foundation

struct CourseCardItem: Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let isTeacher: Bool
    let teacherCount: Int
    let studentCount: Int

    var roleText: String {
        isTeacher ? "Teacher" : "Student"
    }

    var initial: String {
        String(name.prefix(1)).uppercased()
    }

    var participantsText: String {
        "\(teacherCount) teacher\(teacherCount == 1 ? "" : "s") • \(studentCount) student\(studentCount == 1 ? "" : "s")"
    }
}
