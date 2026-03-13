//
//  PostMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum PostMapper {
    static func toDomain(_ dto: PostDTO) throws -> Post {
        Post(
            id: try parseUUID(dto.id),
            title: dto.title,
            content: dto.content,
            type: PostTypeMapper.toDomain(dto.type),
            deadline: try dto.deadline.map(parseDate),
            author: try dto.author.map(UserMapper.toDomain)!,
            materialsCount: dto.materialsCount,
            commentsCount: dto.commentsCount,
            solutionsCount: dto.solutionsCount,
            mySolutionId: try dto.mySolutionId.map(parseUUID),
            createdAt: try dto.createdAt.map(parseDate)!,
            updatedAt: try dto.updatedAt.map(parseDate)!
        )
    }
}
