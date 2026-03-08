//
//  Post.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct Post: Equatable, Sendable, Codable {
    let id: String
    let title: String
    let content: String?
    let type: PostType
    let deadline: String?
    let author: User?
    let materialsCount: Int
    let commentsCount: Int
    let solutionsCount: Int?
    let mySolutionId: String?
    let createdAt: String
    let updatedAt: String
    
    init(id: String, title: String, content: String?, type: PostType, deadline: String?, author: User?, materialsCount: Int, commentsCount: Int, solutionsCount: Int?, mySolutionId: String?, createdAt: String, updatedAt: String) {
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
