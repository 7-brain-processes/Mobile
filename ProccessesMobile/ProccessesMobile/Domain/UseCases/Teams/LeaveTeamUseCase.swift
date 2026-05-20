//
//  LeaveTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol LeaveTeamUseCase: Sendable {
    func execute(_ command: LeaveTeamCommand) async throws -> EnrollmentResponse
}
