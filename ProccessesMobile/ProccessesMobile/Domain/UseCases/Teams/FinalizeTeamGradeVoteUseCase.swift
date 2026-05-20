//
//  FinalizeTeamGradeVoteUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol FinalizeTeamGradeVoteUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeVoteStatus
}

struct DefaultFinalizeTeamGradeVoteUseCase: FinalizeTeamGradeVoteUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeVoteStatus {
        try await repository.finalizeVote(
            courseId: courseId,
            postId: postId,
            teamId: teamId
        )
    }
}
