//
//  DefaultLeaveTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct DefaultLeaveTeamUseCase: LeaveTeamUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: LeaveTeamCommand) async throws -> EnrollmentResponse {
        try await repository.leave(command)
    }
}
