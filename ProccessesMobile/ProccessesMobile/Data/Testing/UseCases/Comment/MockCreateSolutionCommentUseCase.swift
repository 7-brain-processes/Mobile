//
//  MockCreateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockCreateSolutionCommentUseCase: CreateSolutionCommentUseCase {
    private(set) var receivedCommand: CreateSolutionCommentCommand?
    var result: Result<Comment, Error>?

    func execute(_ command: CreateSolutionCommentCommand) async throws -> Comment {
        receivedCommand = command

        guard let result else {
            fatalError("MockCreateSolutionCommentUseCase.result was not set")
        }

        return try result.get()
    }
}
