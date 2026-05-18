//
//  DefaultCreateTeamRequirementTemplateUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//

import Foundation

struct DefaultCreateTeamRequirementTemplateUseCase: CreateTeamRequirementTemplateUseCase {
    let repository: TeamRequirementTemplateRepository

    func execute(
        _ command: CreateTeamRequirementTemplateCommand
    ) async throws -> TeamRequirementTemplate {
        let name = command.name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else {
            throw TeamRequirementTemplateValidationError.emptyName
        }

        if let min = command.minTeamSize, min < 1 {
            throw TeamRequirementTemplateValidationError.invalidMinTeamSize
        }

        if let max = command.maxTeamSize, max < 1 {
            throw TeamRequirementTemplateValidationError.invalidMaxTeamSize
        }

        if let min = command.minTeamSize,
           let max = command.maxTeamSize,
           min > max {
            throw TeamRequirementTemplateValidationError.minGreaterThanMax
        }

        let sanitized = CreateTeamRequirementTemplateCommand(
            courseId: command.courseId,
            name: name,
            description: command.description?.trimmingCharacters(in: .whitespacesAndNewlines),
            minTeamSize: command.minTeamSize,
            maxTeamSize: command.maxTeamSize,
            requiredCategoryId: command.requiredCategoryId,
            requireAudio: command.requireAudio,
            requireVideo: command.requireVideo
        )

        return try await repository.createTemplate(sanitized)
    }
}
