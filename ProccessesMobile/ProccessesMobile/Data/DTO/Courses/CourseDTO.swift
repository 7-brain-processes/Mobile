//
//  Course.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct CourseDTO: Equatable, Sendable, Codable {
    let id: String
    let name: String
    let description: String?
    let createdAt: String
    let currentUserRole: CourseRoleDTO?
    let teacherCount: Int
    let studentCount: Int
    
    init(
        id: String,
        name: String,
        description: String?,
        createdAt: String,
        currentUserRole: CourseRoleDTO?,
        teacherCount: Int,
        studentCount: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.currentUserRole = currentUserRole
        self.teacherCount = teacherCount
        self.studentCount = studentCount
    }
}
