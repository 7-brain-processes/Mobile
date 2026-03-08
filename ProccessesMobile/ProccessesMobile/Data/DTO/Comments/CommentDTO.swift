//
//  Comment.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct CommentDTO: Equatable, Sendable, Codable {
    let id: String
    let text: String
    let author: UserDTO?
    let createdAt: String
    let updatedAt: String
}

extension CommentDTO {
    func toDomain() throws -> Comment {
        Comment(
            id: try parseUUID(id),
            text: text,
            author: try author?.toDomain(),
            createdAt: try parseDate(createdAt),
            updatedAt: try parseDate(updatedAt)
        )
    }
}
