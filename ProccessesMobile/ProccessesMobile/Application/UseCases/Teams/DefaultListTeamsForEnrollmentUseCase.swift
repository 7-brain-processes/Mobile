//
//  DefaultListTeamsForEnrollmentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct DefaultListTeamsForEnrollmentUseCase: ListTeamsForEnrollmentUseCase {
    private let repository: PostTeamsRepository

    init(repository: PostTeamsRepository) {
        self.repository = repository
    }

    func execute(_ query: ListTeamsForEnrollmentQuery) async throws -> [CourseTeamAvailability] {
        try await repository.listTeamsForEnrollment(query)
    }
}
