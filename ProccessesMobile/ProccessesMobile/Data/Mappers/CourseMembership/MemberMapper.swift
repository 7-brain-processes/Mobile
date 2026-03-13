//
//  MemberMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum MemberMapper {
    static func toDomain(_ dto: MemberDTO) throws -> Member {
        let user = try UserMapper.toDomain(dto.user)

        return Member(
            user: user,
            role: CourseRoleMapper.toDomain(dto.role),
            joinedAt: try parseDate(dto.joinedAt),
            id: user.id
        )
    }
}
