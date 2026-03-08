//
//  DefaultCreatePostCommentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultCreatePostCommentUseCase: CreatePostCommentUseCase {
    private let repository: PostCommentsRepository

    init(repository: PostCommentsRepository) {
        self.repository = repository
    }

    func execute(_ command: CreatePostCommentCommand) async throws -> Comment {
        let text = command.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }

        guard text.count <= 5000 else {
            throw InteractionValidationError.invalidCommentLength(min: 1, max: 5000)
        }

        let normalized = CreatePostCommentCommand(
            courseId: command.courseId,
            postId: command.postId,
            text: text
        )

        return try await repository.createComment(normalized)
    }
}
