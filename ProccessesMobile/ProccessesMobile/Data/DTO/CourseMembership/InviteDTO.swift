//
//  Invite.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct InviteDTO: Equatable, Sendable, Codable {
    let id: String
    let code: String
    let role: CourseRoleDTO
    let expiresAt: String?
    let maxUses: Int?
    let currentUses: Int
    let createdAt: String
}

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
