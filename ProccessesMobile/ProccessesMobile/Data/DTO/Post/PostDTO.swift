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
    
    init(id: String, title: String, content: String?, type: PostTypeDTO, deadline: String?, author: UserDTO?, materialsCount: Int, commentsCount: Int, solutionsCount: Int?, mySolutionId: String?, createdAt: String, updatedAt: String) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.deadline = deadline
        self.author = author
        self.materialsCount = materialsCount
        self.commentsCount = commentsCount
        self.solutionsCount = solutionsCount
        self.mySolutionId = mySolutionId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
