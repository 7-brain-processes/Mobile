//
//   CommentMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum CommentMapper {
    static func toDomain(_ dto: CommentDTO) throws -> Comment {
        Comment(
            id: try parseUUID(dto.id),
            text: dto.text,
            author: try dto.author.map(UserMapper.toDomain),
            createdAt: try parseDate(dto.createdAt),
            updatedAt: try parseDate(dto.updatedAt)
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
