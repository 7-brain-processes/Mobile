//
//  DefaultDeleteSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

struct DefaultDeleteSolutionUseCase: DeleteSolutionUseCase {
    let repository: SolutionRepository

    func execute(_ command: DeleteSolutionCommand) async throws {
        try await repository.deleteSolution(command)
    }
}
