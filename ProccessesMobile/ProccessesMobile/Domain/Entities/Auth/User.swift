//
//  User.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct User: Equatable, Codable, Sendable {
    let id: UUID
    let username: String
    let displayName: String?
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

