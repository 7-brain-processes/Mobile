//
//  GradeSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol GradeSolutionUseCase: Sendable {
    func execute(_ command: GradeSolutionCommand) async throws -> Solution
}
