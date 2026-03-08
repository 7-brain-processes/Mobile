//
//  Invite.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Invite: Equatable, Sendable, Codable {
    let id: UUID
    let code: String
    let role: CourseRole
    let expiresAt: Date?
    let maxUses: Int?
    let currentUses: Int
    let createdAt: Date
    
    init(
        id: UUID,
        code: String,
        role: CourseRole,
        expiresAt: Date?,
        maxUses: Int?,
        currentUses: Int,
        createdAt: Date
    ) {
        self.id = id
        self.code = code
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
        self.currentUses = currentUses
        self.createdAt = createdAt
    }
}
