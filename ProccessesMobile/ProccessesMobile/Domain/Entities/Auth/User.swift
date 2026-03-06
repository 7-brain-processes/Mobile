//
//  User.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public nonisolated struct User: Equatable, Codable, Sendable {
    public let id: String
    public let username: String
    public let displayName: String?
    
    public init(id: String, username: String, displayName: String?) {
        self.id = id
        self.username = username
        self.displayName = displayName
    }
}


