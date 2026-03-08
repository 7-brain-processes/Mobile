//
//  Post.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct PostDTO: Equatable, Sendable, Codable {
    let id: String
    let title: String
    let content: String?
    let type: PostTypeDTO
    let deadline: String?
    let author: UserDTO?
    let materialsCount: Int
    let commentsCount: Int
    let solutionsCount: Int?
    let mySolutionId: String?
    let createdAt: String
    let updatedAt: String
}

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
