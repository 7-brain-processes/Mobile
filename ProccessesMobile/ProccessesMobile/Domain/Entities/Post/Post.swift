//
//  Post.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Post: Equatable, Sendable {
    let id: UUID
    let title: String
    let content: String?
    let type: PostType
    let deadline: Date?
    let author: User?
    let materialsCount: Int
    let commentsCount: Int
    let solutionsCount: Int?
    let mySolutionId: UUID?
    let createdAt: Date
    let updatedAt: Date
    
    init(id: UUID, title: String, content: String?, type: PostType, deadline: Date?, author: User?, materialsCount: Int, commentsCount: Int, solutionsCount: Int?, mySolutionId: UUID?, createdAt: Date, updatedAt: Date) {
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
