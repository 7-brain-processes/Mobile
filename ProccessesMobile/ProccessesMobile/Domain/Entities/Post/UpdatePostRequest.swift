//
//  UpdatePostRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct UpdatePostRequest: Equatable, Sendable, Codable {
    public let title: String?
    public let content: String?
    public let deadline: String?
    
    public init(title: String? = nil, content: String? = nil, deadline: String? = nil) {
        self.title = title
        self.content = content
        self.deadline = deadline
    }
}
