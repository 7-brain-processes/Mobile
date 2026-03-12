//
//  CourseRoleMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum CourseRoleMapper {
    static func toDomain(_ dto: CourseRoleDTO) -> CourseRole {
        switch dto {
        case .teacher:
            return .teacher
        case .student:
            return .student
        }
    }

    static func toDTO(_ domain: CourseRole) -> CourseRoleDTO {
        switch domain {
        case .teacher:
            return .teacher
        case .student:
            return .student
        }
    }
}
