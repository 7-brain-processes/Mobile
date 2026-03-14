//
//  DefaultUpdatePostUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultUpdatePostUseCase: UpdatePostUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdatePostCommand) async throws -> Post {
        if let title = command.title {
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedTitle.isEmpty, trimmedTitle.count <= 300 else {
                throw PostValidationError.invalidTitleLength(min: 1, max: 300)
            }
        }

        if let content = command.content, content.count > 10_000 {
            throw PostValidationError.invalidContentLength(max: 10_000)
        }

        return try await repository.updatePost(command)
    }
}
