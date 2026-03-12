//
//  Course.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct CourseDTO: Equatable, Sendable, Codable {
    let id: String
    let name: String
    let description: String?
    let createdAt: String
    let currentUserRole: CourseRoleDTO?
    let teacherCount: Int
    let studentCount: Int
}
