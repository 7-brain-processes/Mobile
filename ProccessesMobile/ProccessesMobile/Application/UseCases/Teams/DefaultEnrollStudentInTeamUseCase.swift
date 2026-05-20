//
//  DefaultEnrollStudentInTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct DefaultEnrollStudentInTeamUseCase: EnrollStudentInTeamUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ command: EnrollStudentInTeamCommand) async throws -> EnrollmentResponse {
        try await repository.enroll(command)
    }
}
