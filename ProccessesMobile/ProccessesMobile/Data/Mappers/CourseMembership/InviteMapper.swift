//
//  InviteMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum InviteMapper {
    static func toDomain(_ dto: InviteDTO) throws -> Invite {
        Invite(
            id: try parseUUID(dto.id),
            code: dto.code,
            role: CourseRoleMapper.toDomain(dto.role),
            expiresAt: try dto.expiresAt.map(parseDate),
            maxUses: dto.maxUses,
            currentUses: dto.currentUses,
            createdAt: try parseDate(dto.createdAt)
        )
    }
}
