//
//  MockSubmitSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockSubmitSolutionUseCase: SubmitSolutionUseCase {
    private(set) var receivedCommand: SubmitSolutionCommand?
    var result: Result<Solution, Error>?

    func execute(_ command: SubmitSolutionCommand) async throws -> Solution {
        receivedCommand = command

        guard let result else {
            fatalError("MockSubmitSolutionUseCase.result was not set")
        }

        return try result.get()
    }
}
