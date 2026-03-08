//
//  AuthResponse.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct AuthResponseDTO: Equatable, Codable, Sendable {
    let token: String
    let user: UserDTO
    
    init(token: String, user: UserDTO) {
        self.token = token
        self.user = user
    }
}
