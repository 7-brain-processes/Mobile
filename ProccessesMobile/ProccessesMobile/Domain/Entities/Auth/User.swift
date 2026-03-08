//
//  User.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct User: Equatable, Codable, Sendable {
    let id: String
    let username: String
    let displayName: String?
    
    init(id: String, username: String, displayName: String?) {
        self.id = id
        self.username = username
        self.displayName = displayName
    }
}


