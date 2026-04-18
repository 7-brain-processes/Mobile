//
//  CourseCategoryMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import Foundation

enum CourseCategoryMapper {
    static func toDomain(_ dto: CourseCategoryDTO) throws -> CourseCategory {
        CourseCategory(
            id: try parseUUID(dto.id),
            title: dto.title,
            description: dto.description,
            isActive: dto.active,
            createdAt: try parseDate(dto.createdAt)
        )
    }

    static func toDTO(_ domain: CourseCategory) -> CourseCategoryDTO {
        CourseCategoryDTO(
            id: domain.id.uuidString,
            title: domain.title,
            description: domain.description,
            active: domain.isActive,
            createdAt: formatDate(domain.createdAt)
        )
    }
}
