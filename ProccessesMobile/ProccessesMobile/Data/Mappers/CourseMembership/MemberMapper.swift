//
//  MemberMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum MemberMapper {
    static func toDomain(_ dto: MemberDTO) throws -> Member {
        Member(
            user: try dto.user.map(UserMapper.toDomain),
            role: CourseRoleMapper.toDomain(dto.role),
            joinedAt: try parseDate(dto.joinedAt)
        )
    }
}
