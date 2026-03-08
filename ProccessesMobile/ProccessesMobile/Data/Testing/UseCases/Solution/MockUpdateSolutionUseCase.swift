//
//  MockUpdateSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

final class MockUpdateSolutionUseCase: UpdateSolutionUseCase {
    private(set) var receivedCommand: UpdateSolutionCommand?
    var result: Result<Solution, Error>?

    func execute(_ command: UpdateSolutionCommand) async throws -> Solution {
        receivedCommand = command

        guard let result else {
            fatalError("MockUpdateSolutionUseCase.result was not set")
        }

        return try result.get()
    }
}
