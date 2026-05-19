//
//  StudentTeamMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum StudentTeamMapper {
    static func toDomain(_ dto: StudentTeamDTO) throws -> StudentTeam {
        StudentTeam(
            teamId: try parseUUID(dto.teamId),
            teamName: dto.teamName,
            membersCount: dto.membersCount,
            maxSize: dto.maxSize,
            members: try (dto.members ?? []).map(CourseTeamMemberMapper.toDomain),
            joinedAt: try dto.joinedAt.map(parseDate) ?? Date()
        )
    }
}
