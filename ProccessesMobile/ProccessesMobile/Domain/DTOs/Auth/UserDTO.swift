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
    
    init(id: String, username: String, displayName: String?) {
        self.id = id
        self.username = username
        self.displayName = displayName
    }
}


