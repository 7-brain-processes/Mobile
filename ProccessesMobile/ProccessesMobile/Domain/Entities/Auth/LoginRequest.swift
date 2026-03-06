//
//  LoginRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public nonisolated struct LoginRequest: Equatable, Codable, Sendable {
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
