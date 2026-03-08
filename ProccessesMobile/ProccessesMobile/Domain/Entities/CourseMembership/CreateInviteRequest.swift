//
//  CreateInviteRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct CreateInviteRequest: Equatable, Sendable, Codable {
    let role: CourseRole
    let expiresAt: Date?
    let maxUses: Int?
    
    init(role: CourseRole, expiresAt: Date? = nil, maxUses: Int? = nil) {
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
    }
}
