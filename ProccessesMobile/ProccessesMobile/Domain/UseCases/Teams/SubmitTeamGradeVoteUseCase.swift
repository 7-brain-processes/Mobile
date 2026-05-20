//
//  SubmitTeamGradeVoteUseCase.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

protocol SubmitTeamGradeVoteUseCase: Sendable {
    func execute(_ command: SubmitTeamGradeVoteCommand) async throws -> TeamGradeVoteStatus
}

struct DefaultSubmitTeamGradeVoteUseCase: SubmitTeamGradeVoteUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: SubmitTeamGradeVoteCommand) async throws -> TeamGradeVoteStatus {
        try await repository.submitVote(command)
    }
}
