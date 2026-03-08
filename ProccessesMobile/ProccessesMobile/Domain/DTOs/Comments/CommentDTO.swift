//
//  Comment.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct CommentDTO: Equatable, Sendable, Codable {
    let id: String
    let text: String
    let author: UserDTO?
    let createdAt: String
    let updatedAt: String
    
    init(id: String, text: String, author: UserDTO?, createdAt: String, updatedAt: String) {
        self.id = id
        self.text = text
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
