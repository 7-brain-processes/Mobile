//
//  GetTeamGradeUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

protocol GetTeamGradeUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGrade
}

struct DefaultGetTeamGradeUseCase: GetTeamGradeUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGrade {
        try await repository.getGrade(
            courseId: courseId,
            postId: postId,
            teamId: teamId
        )
    }
}