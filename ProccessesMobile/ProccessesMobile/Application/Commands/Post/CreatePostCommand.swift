//
//  CreatePostCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct CreatePostCommand: Equatable, Sendable, Codable {
    let courseId: UUID
    let title: String
    let content: String?
    let type: PostType
    let deadline: Date?
}
