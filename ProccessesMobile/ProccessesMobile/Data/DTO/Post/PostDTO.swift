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
