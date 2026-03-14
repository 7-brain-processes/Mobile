//
//  DefaultDeleteSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


struct DefaultDeleteSolutionFileUseCase: DeleteSolutionFileUseCase {
    let repository: SolutionFilesRepository

    func execute(_ command: DeleteSolutionFileCommand) async throws {
        try await repository.deleteSolutionFile(command)
    }
}
