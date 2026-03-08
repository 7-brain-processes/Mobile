//
//  Member.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct MemberDTO: Equatable, Sendable, Codable {
    let user: UserDTO?
    let role: CourseRoleDTO
    let joinedAt: String
    
    init(user: UserDTO?, role: CourseRoleDTO, joinedAt: String) {
        self.user = user
        self.role = role
        self.joinedAt = joinedAt
    }
}
