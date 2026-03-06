//
//  CreateInviteRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct CreateInviteRequest: Equatable, Sendable, Codable {
    public let role: CourseRole
    public let expiresAt: String?
    public let maxUses: Int?
    
    public init(role: CourseRole, expiresAt: String? = nil, maxUses: Int? = nil) {
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
    }
}
