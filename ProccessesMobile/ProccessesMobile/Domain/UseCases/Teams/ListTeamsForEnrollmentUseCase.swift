//
//  ListTeamsForEnrollmentUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol ListTeamsForEnrollmentUseCase: Sendable {
    func execute(_ query: ListTeamsForEnrollmentQuery) async throws -> [CourseTeamAvailability]
}
