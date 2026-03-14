//
//  DefaultUpdateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultUpdateSolutionCommentUseCase: UpdateSolutionCommentUseCase {
    private let repository: SolutionCommentsRepository

    init(repository: SolutionCommentsRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateSolutionCommentCommand) async throws -> Comment {
        let trimmedText = command.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty, trimmedText.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }

        let normalized = UpdateSolutionCommentCommand(
            courseId: command.courseId,
            postId: command.postId,
            solutionId: command.solutionId,
            commentId: command.commentId,
            text: trimmedText
        )

        return try await repository.updateComment(normalized)
    }
}