//
//  DefaultCreatePostUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultCreatePostUseCase: CreatePostUseCase {
    let repository: PostRepository

    func execute(_ command: CreatePostCommand) async throws -> Post {
        let title = command.title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !title.isEmpty else {
            throw PostValidationError.invalidTitleLength(min: 1, max: 300)
        }

        guard title.count <= 300 else {
            throw PostValidationError.invalidTitleLength(min: 1, max: 300)
        }

        if let content = command.content, content.count > 10_000 {
            throw PostValidationError.invalidContentLength(max: 10_000)
        }

        let sanitized = CreatePostCommand(
            courseId: command.courseId,
            title: title,
            content: command.content,
            type: command.type,
            deadline: command.deadline
        )

        return try await repository.createPost(sanitized)
    }
}
