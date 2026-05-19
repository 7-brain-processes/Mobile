//
//  TeamEnrollmentStatusMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum TeamEnrollmentStatusMapper {
    static func toDomain(_ dto: TeamEnrollmentStatusDTO) throws -> TeamEnrollmentStatus {
        TeamEnrollmentStatus(
            teamId: try parseUUID(dto.teamId),
            teamName: dto.teamName,
            currentMembers: dto.currentMembers,
            maxSize: dto.maxSize
        )
    }
}
