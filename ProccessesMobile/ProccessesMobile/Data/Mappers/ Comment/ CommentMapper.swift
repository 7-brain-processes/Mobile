//
//   CommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

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

extension Comment {
    func toDTO() -> CommentDTO {
        CommentDTO(
            id: id.uuidString,
            text: text,
            author: author?.toDTO(),
            createdAt: formatDate(createdAt),
            updatedAt: formatDate(updatedAt)
        )
    }
}
