//
//  AuthResponse.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct AuthResponse: Equatable, Codable, Sendable {
    let token: String
    let user: User
    
    init(token: String, user: User) {
        self.token = token
        self.user = user
    }
}
