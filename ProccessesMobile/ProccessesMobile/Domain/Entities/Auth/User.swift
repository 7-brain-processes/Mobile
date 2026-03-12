//
//  User.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct User: Equatable, Codable, Sendable {
    let id: UUID
    let username: String
    let displayName: String?
}
