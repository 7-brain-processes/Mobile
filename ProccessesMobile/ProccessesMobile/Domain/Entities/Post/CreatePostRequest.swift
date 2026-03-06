//
//  CreatePostRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct CreatePostRequest: Equatable, Sendable, Codable {
    public let title: String
    public let content: String?
    public let type: PostType
    public let deadline: String?
    
    public init(title: String, content: String? = nil, type: PostType, deadline: String? = nil) {
        self.title = title
        self.content = content
        self.type = type
        self.deadline = deadline
    }
}