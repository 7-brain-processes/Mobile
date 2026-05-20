//
//  GetTeamGradeDistributionUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol GetTeamGradeDistributionUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeDistribution
}

struct DefaultGetTeamGradeDistributionUseCase: GetTeamGradeDistributionUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeDistribution {
        try await repository.getGradeDistribution(
            courseId: courseId,
            postId: postId,
            teamId: teamId
        )
    }
}
