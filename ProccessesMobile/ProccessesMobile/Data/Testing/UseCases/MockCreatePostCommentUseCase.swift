//
//  MockCreatePostCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockCreatePostCommentUseCase: CreatePostCommentUseCase {
    private let repository: PostCommentsRepository
    public init(repository: PostCommentsRepository) { self.repository = repository }
    
    public func execute(courseId: String, postId: String, request: CreateCommentRequest) async throws -> Comment {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("courseId") }
        guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("postId") }
        
        let trimmedText = request.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedText.count >= 1 && trimmedText.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }
        
        return try await repository.createComment(courseId: courseId, postId: postId, request: CreateCommentRequest(text: trimmedText))
    }
}
