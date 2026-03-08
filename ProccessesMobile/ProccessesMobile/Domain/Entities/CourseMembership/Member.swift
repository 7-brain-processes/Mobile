//
//  Member.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Member: Equatable, Sendable, Codable {
    let user: User?
    let role: CourseRole
    let joinedAt: Date
    
    init(user: User?, role: CourseRole, joinedAt: Date) {
        self.user = user
        self.role = role
        self.joinedAt = joinedAt
    }
}
