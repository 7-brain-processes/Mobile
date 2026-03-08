//
//  MockDeleteSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockDeleteSolutionUseCase: DeleteSolutionUseCase {
    private(set) var receivedCommand: DeleteSolutionCommand?
    var error: Error?

    func execute(_ command: DeleteSolutionCommand) async throws {
        receivedCommand = command

        if let error {
            throw error
        }
    }
}
