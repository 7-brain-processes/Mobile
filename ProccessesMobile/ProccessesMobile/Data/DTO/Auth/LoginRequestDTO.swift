//
//  LoginRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct LoginRequestDTO: Equatable, Codable, Sendable {
    let username: String
    let password: String
}
