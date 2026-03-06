//
//  Course.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public nonisolated struct Course: Equatable, Sendable, Codable {
    public let id: String
    public let name: String
    public let description: String?
    public let createdAt: String
    public let currentUserRole: CourseRole?
    public let teacherCount: Int
    public let studentCount: Int
    
    public init(id: String, name: String, description: String?, createdAt: String, currentUserRole: CourseRole?, teacherCount: Int, studentCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.currentUserRole = currentUserRole
        self.teacherCount = teacherCount
        self.studentCount = studentCount
    }
}
