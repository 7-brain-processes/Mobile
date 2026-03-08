//
//  RegisterRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct RegisterRequestDTO: Equatable, Codable, Sendable {
    let username: String
    let password: String
    let displayName: String?
    
    init(username: String, password: String, displayName: String? = nil) {
        self.username = username
        self.password = password
        self.displayName = displayName
    }
}
