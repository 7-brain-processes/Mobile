//
//  Course.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Course: Equatable, Sendable, Codable {
    let id: UUID
    let name: String
    let description: String?
    let createdAt: Date
    let currentUserRole: CourseRole?
    let teacherCount: Int
    let studentCount: Int
    
    init(id: UUID, name: String, description: String?, createdAt: Date, currentUserRole: CourseRole?, teacherCount: Int, studentCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.currentUserRole = currentUserRole
        self.teacherCount = teacherCount
        self.studentCount = studentCount
    }
}
