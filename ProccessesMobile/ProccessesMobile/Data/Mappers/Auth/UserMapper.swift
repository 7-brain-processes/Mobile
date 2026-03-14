//
//  UserMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum UserMapper {
    static func toDomain(_ dto: UserDTO) throws -> User {
        User(
            id: try parseUUID(dto.id),
            username: dto.username,
            displayName: dto.displayName
        )
    }

    static func toDTO(_ domain: User) -> UserDTO {
        UserDTO(
            id: domain.id.uuidString,
            username: domain.username,
            displayName: domain.displayName
        )
    }
}
