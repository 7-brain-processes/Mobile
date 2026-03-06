//
//  RegisterRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct RegisterRequest: Equatable, Codable, Sendable {
    public let username: String
    public let password: String
    public let displayName: String?
    
    public init(username: String, password: String, displayName: String? = nil) {
        self.username = username
        self.password = password
        self.displayName = displayName
    }
}
