//
//  CourseMembershipMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension InviteDTO {

    func toDomain() throws -> Invite {
        Invite(
            id: try parseUUID(id),
            code: code,
            role: role.toDomain(),
            expiresAt: try expiresAt.map(parseDate),
            maxUses: maxUses,
            currentUses: currentUses,
            createdAt: try parseDate(createdAt)
        )
    }
}
