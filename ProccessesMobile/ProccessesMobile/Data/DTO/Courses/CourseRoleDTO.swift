//
//  CourseRole.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum CourseRoleDTO: String, Codable, Equatable, Sendable {
    case teacher = "TEACHER"
    case student = "STUDENT"
}

extension CourseRoleDTO {

    func toDomain() -> CourseRole {
        switch self {
        case .teacher:
            return .teacher
        case .student:
            return .student
        }
    }
}
