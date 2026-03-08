//
//  MockDeleteSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockDeleteSolutionCommentUseCase: DeleteSolutionCommentUseCase {
    let repo: SolutionCommentsRepository
    func execute(courseId: String, postId: String, solutionId: String, commentId: String) async throws {
        guard !commentId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("commentId") }
        try await repo.deleteComment(courseId: courseId, postId: postId, solutionId: solutionId, commentId: commentId)
    }
}
