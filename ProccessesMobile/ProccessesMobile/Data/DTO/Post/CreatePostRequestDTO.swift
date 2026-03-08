//
//  CreatePostRequest.swift
//  ProccessesMobile
//
//  Created Tark Wight on 07.03.2026.
//

struct CreatePostRequestDTO: Equatable, Sendable, Codable {
    let title: String
    let content: String?
    let type: PostTypeDTO
    let deadline: String?
    
    init(title: String, content: String? = nil, type: PostTypeDTO, deadline: String? = nil) {
        self.title = title
        self.content = content
        self.type = type
        self.deadline = deadline
    }
}
