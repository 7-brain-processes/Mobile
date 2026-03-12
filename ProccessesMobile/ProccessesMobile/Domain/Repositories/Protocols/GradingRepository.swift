//
//  GradingRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GradingRepository: Sendable {
    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution
}
