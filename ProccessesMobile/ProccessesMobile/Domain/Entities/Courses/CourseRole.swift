//
//  CourseRole.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseRole: String, Equatable, Sendable {
    case teacher = "TEACHER"
    case student = "STUDENT"
}

extension CourseRole {
    func toDTO() -> CourseRoleDTO {
        switch self {
        case .teacher: return .teacher
        case .student: return .student
        }
    }
}
