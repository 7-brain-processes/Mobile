//
//  MockCreateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockCreateSolutionCommentUseCase: CreateSolutionCommentUseCase {
    let repo: SolutionCommentsRepository
    func execute(courseId: String, postId: String, solutionId: String, request: CreateCommentRequest) async throws -> Comment {
        guard !solutionId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("solutionId") }
        
        let trimmedText = request.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedText.count >= 1 && trimmedText.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }
        return try await repo.createComment(courseId: courseId, postId: postId, solutionId: solutionId, request: CreateCommentRequest(text: trimmedText))
    }
}
