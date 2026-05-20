//
//  UpdateGradingConfigUseCase.swift
//  ProccessesMobile
//

import Foundation

protocol UpdateGradingConfigUseCase: Sendable {
    func execute(_ command: UpsertGradingConfigCommand) async throws -> AssessmentConfig
}

struct DefaultUpdateGradingConfigUseCase: UpdateGradingConfigUseCase {
    private let repository: AssessmentRepository

    init(repository: AssessmentRepository) {
        self.repository = repository
    }

    func execute(_ command: UpsertGradingConfigCommand) async throws -> AssessmentConfig {
        try validate(command.config)
        return try await repository.upsertConfig(command)
    }

    private func validate(_ config: AssessmentConfig) throws {
        guard config.maxGrade > 0 else {
            throw AssessmentValidationError.invalidMaxGrade
        }

        guard !config.criteria.isEmpty else {
            throw AssessmentValidationError.emptyCriteriaRequired
        }

        for criterion in config.criteria {
            let title = criterion.title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !title.isEmpty else {
                throw AssessmentValidationError.emptyCriterionTitle
            }

            guard criterion.maxPoints > 0 else {
                throw AssessmentValidationError.invalidMaxPoints
            }
        }
    }
}
