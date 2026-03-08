//
//  CreatePostRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct CreatePostRequest: Equatable, Sendable, Codable {
    let title: String
    let content: String?
    let type: PostType
    let deadline: String?
    
    init(title: String, content: String? = nil, type: PostType, deadline: String? = nil) {
        self.title = title
        self.content = content
        self.type = type
        self.deadline = deadline
    }
}