//
//  Member.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct Member: Equatable, Sendable, Codable {
    let user: User?
    let role: CourseRole
    let joinedAt: String
    
    init(user: User?, role: CourseRole, joinedAt: String) {
        self.user = user
        self.role = role
        self.joinedAt = joinedAt
    }
}
