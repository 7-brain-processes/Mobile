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
}

extension MemberDTO {
    func toDomain() throws -> Member {
        Member(
            user: try user?.toDomain(),
            role: role.toDomain(),
            joinedAt: try parseDate(joinedAt)
        )
    }
}
