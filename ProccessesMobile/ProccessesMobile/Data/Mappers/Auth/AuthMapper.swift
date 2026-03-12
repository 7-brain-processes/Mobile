//
//  AuthMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension UserDTO {
    func toDomain() throws -> User {
        User(
            id: try parseUUID(id),
            username: username,
            displayName: displayName
        )
    }
}

extension User {
    func toDTO() -> UserDTO {
        UserDTO(
            id: id.uuidString,
            username: username,
            displayName: displayName
        )
    }
}

