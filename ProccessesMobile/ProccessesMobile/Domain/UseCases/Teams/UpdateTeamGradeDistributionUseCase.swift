//
//  UpdateTeamGradeDistributionUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol UpdateTeamGradeDistributionUseCase: Sendable {
    func execute(_ command: UpdateTeamGradeDistributionCommand) async throws -> TeamGradeDistribution
}

struct DefaultUpdateTeamGradeDistributionUseCase: UpdateTeamGradeDistributionUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateTeamGradeDistributionCommand) async throws -> TeamGradeDistribution {
        try await repository.updateGradeDistribution(command)
    }
}
