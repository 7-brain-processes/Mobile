//
//  Course.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct Course: Equatable, Sendable, Codable {
    let id: String
    let name: String
    let description: String?
    let createdAt: String
    let currentUserRole: CourseRole?
    let teacherCount: Int
    let studentCount: Int
    
    init(id: String, name: String, description: String?, createdAt: String, currentUserRole: CourseRole?, teacherCount: Int, studentCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.currentUserRole = currentUserRole
        self.teacherCount = teacherCount
        self.studentCount = studentCount
    }
}
