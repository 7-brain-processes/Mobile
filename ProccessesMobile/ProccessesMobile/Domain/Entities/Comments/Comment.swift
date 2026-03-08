//
//  Comment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Comment: Equatable, Sendable, Codable {
    let id: UUID
    let text: String
    let author: User?
    let createdAt: Date
    let updatedAt: Date
    
    init(id: UUID, text: String, author: User?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.text = text
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
