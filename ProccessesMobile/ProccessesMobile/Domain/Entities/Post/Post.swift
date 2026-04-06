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
    let author: User
    let materialsCount: Int
    let commentsCount: Int
    let solutionsCount: Int?
    let mySolutionId: UUID?
    let createdAt: Date
    let updatedAt: Date
}
