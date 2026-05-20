//
//  EnrollStudentInTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol EnrollStudentInTeamUseCase: Sendable {
    func execute(_ command: EnrollStudentInTeamCommand) async throws -> EnrollmentResponse
}