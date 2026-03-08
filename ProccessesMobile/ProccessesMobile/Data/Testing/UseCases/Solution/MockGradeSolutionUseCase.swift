//
//  MockGradeSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockGradeSolutionUseCase: GradeSolutionUseCase {
    private(set) var receivedCommand: GradeSolutionCommand?
    var result: Result<Solution, Error>?

    func execute(_ command: GradeSolutionCommand) async throws -> Solution {
        receivedCommand = command

        guard let result else {
            fatalError("MockGradeSolutionUseCase.result was not set")
        }

        return try result.get()
    }
}
