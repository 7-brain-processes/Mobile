//
//  Comment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct Comment: Equatable, Sendable, Codable {
    public let id: String
    public let text: String
    public let author: User?
    public let createdAt: String
    public let updatedAt: String
    
    public init(id: String, text: String, author: User?, createdAt: String, updatedAt: String) {
        self.id = id
        self.text = text
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}