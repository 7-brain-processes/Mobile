//
//  GetTeacherTeamGradeVoteStatusUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol GetTeacherTeamGradeVoteStatusUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeVoteStatus
}

struct DefaultGetTeacherTeamGradeVoteStatusUseCase: GetTeacherTeamGradeVoteStatusUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGradeVoteStatus {
        try await repository.getTeacherVoteStatus(
            courseId: courseId,
            postId: postId,
            teamId: teamId
        )
    }
}
