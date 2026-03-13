//
//  GradingRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GradingRepository: Sendable {
    // TODO: - ADD DELETE
    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution
}
