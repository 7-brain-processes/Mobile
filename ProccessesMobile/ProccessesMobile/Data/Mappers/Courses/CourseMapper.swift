//
//  CourseMappers.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum CourseMapper {
    static func toDomain(_ dto: CourseDTO) throws -> Course {
        Course(
            id: try parseUUID(dto.id),
            name: dto.name,
            description: dto.description,
            createdAt: try parseDate(dto.createdAt),
            currentUserRole: dto.currentUserRole.map(CourseRoleMapper.toDomain),
            teacherCount: dto.teacherCount,
            studentCount: dto.studentCount
        )
    }
}
