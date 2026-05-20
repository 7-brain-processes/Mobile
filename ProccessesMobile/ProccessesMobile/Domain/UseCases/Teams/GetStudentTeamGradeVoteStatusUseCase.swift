//
//  GetStudentTeamGradeVoteStatusUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol GetStudentTeamGradeVoteStatusUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID) async throws -> TeamGradeVoteStatus
}

struct DefaultGetStudentTeamGradeVoteStatusUseCase: GetStudentTeamGradeVoteStatusUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID) async throws -> TeamGradeVoteStatus {
        try await repository.getStudentVoteStatus(
            courseId: courseId,
            postId: postId
        )
    }
}
