//
//  AuthResponse.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public nonisolated struct AuthResponse: Equatable, Codable, Sendable {
    public let token: String
    public let user: User
    
    public init(token: String, user: User) {
        self.token = token
        self.user = user
    }
}
