//
//  TeamRequirementTemplateMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

enum TeamRequirementTemplateMapper {
    static func toDomain(_ dto: TeamRequirementTemplateDTO) throws -> TeamRequirementTemplate {
        TeamRequirementTemplate(
            id: try parseUUID(dto.id),
            name: dto.name,
            description: dto.description,
            minTeamSize: dto.minTeamSize,
            maxTeamSize: dto.maxTeamSize,
            requiredCategory: try dto.requiredCategory.map(CourseCategoryMapper.toDomain),
            requireAudio: dto.requireAudio,
            requireVideo: dto.requireVideo,
            active: dto.active,
            createdAt: try parseDate(dto.createdAt),
            archivedAt: try dto.archivedAt.map(parseDate)
        )
    }
}