//
//  MockUpdateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockUpdateSolutionCommentUseCase: UpdateSolutionCommentUseCase {
    private(set) var receivedCommand: UpdateSolutionCommentCommand?
    var result: Result<Comment, Error>?

    func execute(_ command: UpdateSolutionCommentCommand) async throws -> Comment {
        receivedCommand = command

        guard let result else {
            fatalError("MockUpdateSolutionCommentUseCase.result was not set")
        }

        return try result.get()
    }
}
