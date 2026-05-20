//
//  ListCourseTeamsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

protocol ListCourseTeamsUseCase: Sendable {
    func execute(courseId: UUID) async throws -> [CourseTeam]
}

struct DefaultListCourseTeamsUseCase: ListCourseTeamsUseCase {
    private let repository: CourseTeamsRepository

    init(repository: CourseTeamsRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID) async throws -> [CourseTeam] {
        try await repository.listTeams(
            ListCourseTeamsQuery(courseId: courseId)
        )
    }
}