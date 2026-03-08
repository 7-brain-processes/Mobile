//
//  LoginRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct LoginRequest: Equatable, Codable, Sendable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
