//
//  DefaultCreateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultCreateSolutionCommentUseCase: CreateSolutionCommentUseCase {
    let repository: SolutionCommentsRepository

    func execute(_ command: CreateSolutionCommentCommand) async throws -> Comment {
        let trimmedText = command.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty, trimmedText.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }

        let normalized = CreateSolutionCommentCommand(
            courseId: command.courseId,
            postId: command.postId,
            solutionId: command.solutionId,
            text: trimmedText
        )

        return try await repository.createComment(normalized)
    }
}
