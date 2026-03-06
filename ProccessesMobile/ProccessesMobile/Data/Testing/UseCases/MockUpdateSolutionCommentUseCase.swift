//
//  MockUpdateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockUpdateSolutionCommentUseCase: UpdateSolutionCommentUseCase {
    let repo: SolutionCommentsRepository
    public func execute(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment {
        guard !commentId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("commentId") }
        
        let trimmedText = request.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedText.count >= 1 && trimmedText.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }
        return try await repo.updateComment(courseId: courseId, postId: postId, solutionId: solutionId, commentId: commentId, request: CreateCommentRequest(text: trimmedText))
    }
}
