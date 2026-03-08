//
//  DefaultUpdateSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultUpdateSolutionUseCase: UpdateSolutionUseCase {
    private let repository: SolutionRepository

    init(repository: SolutionRepository) {
        self.repository = repository
    }

    func execute(_ command: UpdateSolutionCommand) async throws -> Solution {
        if let text = command.text, text.count > 10_000 {
            throw SolutionValidationError.invalidTextLength(max: 10_000)
        }

        return try await repository.updateSolution(command)
    }
}
