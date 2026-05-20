//
//   CommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum CommentMapper {
    static func toDomain(_ dto: CommentDTO) throws -> Comment {
        let createdAt = try dto.createdAt.map(parseDate) ?? Date()
        let updatedAt = try dto.updatedAt.map(parseDate) ?? createdAt

        return Comment(
            id: try parseUUID(dto.id),
            text: dto.text,
            author: try dto.author.map(UserMapper.toDomain),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    static func toDTO(_ domain: Comment) -> CommentDTO {
        CommentDTO(
            id: domain.id.uuidString,
            text: domain.text,
            author: domain.author.map(UserMapper.toDTO),
            createdAt: formatDate(domain.createdAt),
            updatedAt: formatDate(domain.updatedAt)
        )
    }
}
