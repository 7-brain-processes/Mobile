//
//  MockListPostsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockListPostsUseCase: ListPostsUseCase {
    let repo: PostRepository
    
    public func execute(courseId: String, page: Int, size: Int, type: PostType?) async throws -> PagePost {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw PostValidationError.emptyCourseId }
        return try await repo.listPosts(courseId: courseId, page: max(0, page), size: min(max(1, size), 100), type: type)
    }
}
