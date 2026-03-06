//
//  MockCreatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockCreatePostUseCase: CreatePostUseCase {
    let repo: PostRepository
    
    public func execute(courseId: String, request: CreatePostRequest) async throws -> Post {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw PostValidationError.emptyCourseId }
        
        let title = request.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard title.count >= 1 && title.count <= 300 else { throw PostValidationError.invalidTitleLength(min: 1, max: 300) }
        
        if let content = request.content, content.count > 10000 {
            throw PostValidationError.invalidContentLength(max: 10000)
        }
        
        let sanitized = CreatePostRequest(title: title, content: request.content, type: request.type, deadline: request.deadline)
        return try await repo.createPost(courseId: courseId, request: sanitized)
    }
}
