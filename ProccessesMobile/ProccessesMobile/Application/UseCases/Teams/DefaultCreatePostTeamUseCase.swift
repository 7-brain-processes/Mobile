//
//  DefaultCreatePostTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

struct DefaultCreatePostTeamUseCase: CreatePostTeamUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: CreatePostTeamCommand) async throws -> CourseTeamAvailability {
        let trimmedName = command.name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            throw CreatePostTeamValidationError.emptyName
        }

        if let maxSize = command.maxSize, maxSize < 1 {
            throw CreatePostTeamValidationError.invalidMaxSize
        }

        return try await repository.create(
            CreatePostTeamCommand(
                courseId: command.courseId,
                postId: command.postId,
                name: trimmedName,
                maxSize: command.maxSize,
                selfEnrollmentEnabled: command.selfEnrollmentEnabled
            )
        )
    }
}
