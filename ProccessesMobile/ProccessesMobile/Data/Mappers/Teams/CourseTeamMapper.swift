//
//  CourseTeamMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

enum CourseTeamMapper {
    static func toDomain(_ dto: CourseTeamDTO) throws -> CourseTeam {
        CourseTeam(
            id: try parseUUID(dto.id),
            postId: try dto.postId.map(parseUUID),
            name: dto.name,
            membersCount: dto.membersCount,
            maxSize: dto.maxSize,
            selfEnrollmentEnabled: dto.selfEnrollmentEnabled,
            categories: try (dto.categories ?? []).map(CourseCategoryMapper.toDomain),
            teamGrade: dto.teamGrade,
            createdAt: try dto.createdAt.map(parseDate)
        )
    }
}