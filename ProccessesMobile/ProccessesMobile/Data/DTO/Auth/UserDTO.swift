//
//  User.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct UserDTO: Equatable, Codable, Sendable {
    let id: String
    let username: String
    let displayName: String?
}

extension UserDTO {
    func toDomain() throws -> User {
        User(
            id: try parseUUID(id),
            username: username,
            displayName: displayName
        )
    }
}
