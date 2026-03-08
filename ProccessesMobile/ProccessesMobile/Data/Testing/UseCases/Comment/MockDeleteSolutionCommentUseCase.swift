//
//  MockDeleteSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockDeleteSolutionCommentUseCase: DeleteSolutionCommentUseCase {
    private(set) var receivedCommand: DeleteSolutionCommentCommand?
    var error: Error?

    func execute(_ command: DeleteSolutionCommentCommand) async throws {
        receivedCommand = command

        if let error {
            throw error
        }
    }
}
