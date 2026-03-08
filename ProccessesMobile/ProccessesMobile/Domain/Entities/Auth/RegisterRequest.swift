//
//  RegisterRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct RegisterRequest: Equatable, Codable, Sendable {
    let username: String
    let password: String
    let displayName: String?
    
    init(username: String, password: String, displayName: String? = nil) {
        self.username = username
        self.password = password
        self.displayName = displayName
    }
}
