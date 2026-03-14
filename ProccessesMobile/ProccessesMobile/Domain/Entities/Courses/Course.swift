//
//  Course.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Course: Equatable, Sendable {
    let id: UUID
    let name: String
    let description: String?
    let createdAt: Date
    let currentUserRole: CourseRole?
    let teacherCount: Int
    let studentCount: Int
}
