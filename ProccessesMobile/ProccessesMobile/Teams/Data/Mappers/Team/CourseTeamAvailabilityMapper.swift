//
//  CourseTeamAvailabilityMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum CourseTeamAvailabilityMapper {
    static func toDomain(_ dto: CourseTeamAvailabilityDTO) throws -> CourseTeamAvailability {
        CourseTeamAvailability(
            id: try parseUUID(dto.id),
            name: dto.name,
            currentMembers: dto.currentMembers,
            maxSize: dto.maxSize,
            selfEnrollmentEnabled: dto.selfEnrollmentEnabled,
            isFull: dto.isFull,
            isStudentMember: dto.isStudentMember,
            categories: try (dto.categories ?? []).map(CourseCategoryMapper.toDomain),
            createdAt: try dto.createdAt.map(parseDate) ?? Date()
        )
    }
}

