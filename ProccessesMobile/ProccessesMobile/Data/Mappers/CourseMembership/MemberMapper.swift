//
//  MemberMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension MemberDTO {
    func toDomain() throws -> Member {
        Member(
            user: try user?.toDomain(),
            role: role.toDomain(),
            joinedAt: try parseDate(joinedAt)
        )
    }
}
