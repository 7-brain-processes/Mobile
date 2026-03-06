//
//  Post.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct Post: Equatable, Sendable, Codable {
    public let id: String
    public let title: String
    public let content: String?
    public let type: PostType
    public let deadline: String?
    public let author: User?
    public let materialsCount: Int
    public let commentsCount: Int
    public let solutionsCount: Int?
    public let mySolutionId: String?
    public let createdAt: String
    public let updatedAt: String
    
    public init(id: String, title: String, content: String?, type: PostType, deadline: String?, author: User?, materialsCount: Int, commentsCount: Int, solutionsCount: Int?, mySolutionId: String?, createdAt: String, updatedAt: String) {
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
