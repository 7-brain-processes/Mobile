//
//  Invite.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct Invite: Equatable, Sendable, Codable {
    public let id: String
    public let code: String
    public let role: CourseRole
    public let expiresAt: String?
    public let maxUses: Int?
    public let currentUses: Int
    public let createdAt: String
    
    public init(id: String, code: String, role: CourseRole, expiresAt: String?, maxUses: Int?, currentUses: Int, createdAt: String) {
        self.id = id
        self.code = code
        self.role = role
        self.expiresAt = expiresAt
        self.maxUses = maxUses
        self.currentUses = currentUses
        self.createdAt = createdAt
    }
}
