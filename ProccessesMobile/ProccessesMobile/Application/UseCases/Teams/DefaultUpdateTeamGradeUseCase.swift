//
//  DefaultUpdateTeamGradeUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct DefaultUpdateTeamGradeUseCase: UpdateTeamGradeUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateTeamGradeCommand) async throws -> TeamGrade {
        guard command.grade >= 0 && command.grade <= 100 else {
            throw InteractionValidationError.invalidGrade(min: 0, max: 100)
        }

        return try await repository.updateGrade(command)
    }
}

