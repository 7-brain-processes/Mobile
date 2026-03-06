//
//  MockUpdatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockUpdatePostUseCase: UpdatePostUseCase {
    let repo: PostRepository
    
    public func execute(courseId: String, postId: String, request: UpdatePostRequest) async throws -> Post {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw PostValidationError.emptyCourseId }
        guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw PostValidationError.emptyPostId }
        
        if let title = request.title {
            let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count >= 1 && trimmed.count <= 300 else { throw PostValidationError.invalidTitleLength(min: 1, max: 300) }
        }
        
        if let content = request.content, content.count > 10000 {
            throw PostValidationError.invalidContentLength(max: 10000)
        }
        
        return try await repo.updatePost(courseId: courseId, postId: postId, request: request)
    }
}
