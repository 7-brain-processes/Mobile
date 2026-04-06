//
//  Invite.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Invite: Equatable, Sendable {
    let id: UUID
    let code: String
    let role: CourseRole
    let expiresAt: Date?
    let maxUses: Int?
    let currentUses: Int
    let createdAt: Date
}

