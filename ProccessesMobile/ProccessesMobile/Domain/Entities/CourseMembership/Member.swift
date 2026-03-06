//
//  Member.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct Member: Equatable, Sendable, Codable {
    public let user: User?
    public let role: CourseRole
    public let joinedAt: String
    
    public init(user: User?, role: CourseRole, joinedAt: String) {
        self.user = user
        self.role = role
        self.joinedAt = joinedAt
    }
}
