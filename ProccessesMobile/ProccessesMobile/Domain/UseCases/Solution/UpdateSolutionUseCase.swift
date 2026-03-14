//
//  UpdateSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol UpdateSolutionUseCase: Sendable {
    func execute(_ command: UpdateSolutionCommand) async throws -> Solution
}
