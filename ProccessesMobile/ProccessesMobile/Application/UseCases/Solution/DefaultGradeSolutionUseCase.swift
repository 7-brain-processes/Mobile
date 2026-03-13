//
//  DefaultGradeSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultGradeSolutionUseCase: GradeSolutionUseCase {
    private let repository: GradingRepository

    init(repository: GradingRepository) {
        self.repository = repository
    }

    func execute(_ command: GradeSolutionCommand) async throws -> Solution {
        guard command.grade >= 0 && command.grade <= 100 else {
            throw InteractionValidationError.invalidGrade(min: 0, max: 100)
        }

        if let comment = command.comment, comment.count > 5000 {
            throw InteractionValidationError.invalidCommentLength(min: 0, max: 5000)
        }

        return try await repository.gradeSolution(command)
    }

    func execute(_ command: RemoveGradeCommand) async throws -> Solution {
        try await repository.removeGrade(command)
    }
}
