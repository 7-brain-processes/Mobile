//
//  CourseMappers.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension CourseDTO {

    func toDomain() throws -> Course {
        Course(
            id: try parseUUID(id),
            name: name,
            description: description,
            createdAt: try parseDate(createdAt),
            currentUserRole: currentUserRole?.toDomain(),
            teacherCount: teacherCount,
            studentCount: studentCount
        )
    }
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

extension CourseRole {
    func toDTO() -> CourseRoleDTO {
        switch self {
        case .teacher: return .teacher
        case .student: return .student
        }
    }
}

extension UpdateCourseRequestDTO {
    func toCommand(courseId: UUID) -> UpdateCourseCommand {
        UpdateCourseCommand(
            courseId: courseId,
            name: name,
            description: description
        )
    }
}

extension UpdateCourseCommand {
    func toDTO() -> UpdateCourseRequestDTO {
        UpdateCourseRequestDTO(
            name: name,
            description: description
        )
    }
}

