//
//  Comment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct Comment: Equatable, Sendable, Codable {
    let id: String
    let text: String
    let author: User?
    let createdAt: String
    let updatedAt: String
    
    init(id: String, text: String, author: User?, createdAt: String, updatedAt: String) {
        self.id = id
        self.text = text
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}