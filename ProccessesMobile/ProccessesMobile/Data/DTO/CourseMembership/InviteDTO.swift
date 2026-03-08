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
    
    init(id: String, code: String, role: CourseRoleDTO, expiresAt: String?, maxUses: Int?, currentUses: Int, createdAt: String) {
        self.id = id
        self.code = code
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
        self.currentUses = currentUses
        self.createdAt = createdAt
    }
}
