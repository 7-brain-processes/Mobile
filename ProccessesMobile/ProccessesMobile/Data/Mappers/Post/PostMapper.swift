//
//  PostMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

extension PostDTO {
    func toDomain() throws -> Post {
        Post(
            id: try parseUUID(id),
            title: title,
            content: content,
            type: type.toDomain(),
            deadline: try deadline.map(parseDate),
            author: try author?.toDomain(),
            materialsCount: materialsCount,
            commentsCount: commentsCount,
            solutionsCount: solutionsCount,
            mySolutionId: try mySolutionId.map(parseUUID),
            createdAt: try parseDate(createdAt),
            updatedAt: try parseDate(updatedAt)
        )
    }
}

extension PostTypeDTO {
    func toDomain() -> PostType {
        switch self {
        case .material: return .material
        case .task: return .task
        }
    }
}

extension PostType {
    func toDTO() -> PostTypeDTO {
        switch self {
        case .material: return .material
        case .task: return .task
        }
    }
}

