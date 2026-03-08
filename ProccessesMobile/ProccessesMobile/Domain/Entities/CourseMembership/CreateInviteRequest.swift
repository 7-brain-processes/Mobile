//
//  CreateInviteRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct CreateInviteRequest: Equatable, Sendable, Codable {
    let role: CourseRole
    let expiresAt: String?
    let maxUses: Int?
    
    init(role: CourseRole, expiresAt: String? = nil, maxUses: Int? = nil) {
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
    }
}
