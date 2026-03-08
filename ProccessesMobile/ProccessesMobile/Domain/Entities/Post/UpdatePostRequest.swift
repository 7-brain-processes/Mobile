//
//  UpdatePostRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct UpdatePostRequest: Equatable, Sendable, Codable {
    let title: String?
    let content: String?
    let deadline: String?
    
    init(title: String? = nil, content: String? = nil, deadline: String? = nil) {
        self.title = title
        self.content = content
        self.deadline = deadline
    }
}
