//
//  CreateInviteRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct CreateInviteRequestDTO: Equatable, Sendable, Codable {
    let role: CourseRoleDTO
    let expiresAt: String?
    let maxUses: Int?
    
    init(role: CourseRoleDTO, expiresAt: String? = nil, maxUses: Int? = nil) {
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
    }
}
