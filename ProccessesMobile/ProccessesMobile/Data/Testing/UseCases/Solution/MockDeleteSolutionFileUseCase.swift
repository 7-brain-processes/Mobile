//
//  MockDeleteSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockDeleteSolutionFileUseCase: DeleteSolutionFileUseCase {
    private(set) var receivedCommand: DeleteSolutionFileCommand?
    var error: Error?

    func execute(_ command: DeleteSolutionFileCommand) async throws {
        receivedCommand = command

        if let error {
            throw error
        }
    }
}
