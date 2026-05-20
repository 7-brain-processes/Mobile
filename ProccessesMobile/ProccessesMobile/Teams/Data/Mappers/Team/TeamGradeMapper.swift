//
//  TeamGradeMapper.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

enum TeamGradeMapper {
    static func toDTO(_ command: UpdateTeamGradeCommand) -> TeamGradeRequestDTO {
        TeamGradeRequestDTO(grade: command.grade)
    }

    static func toDomain(_ dto: TeamGradeDTO) throws -> TeamGrade {
        TeamGrade(
            id: try dto.id.map(parseUUID),
            postId: try parseUUID(dto.postId),
            teamId: try parseUUID(dto.teamId),
            grade: dto.grade,
            comment: dto.comment,
            distributionMode: dto.distributionMode,
            updatedAt: try dto.updatedAt.map(parseDate)
        )
    }
}
