//
//  MockCreatePostCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockCreatePostCommentUseCase: CreatePostCommentUseCase {
    var receivedCommand: CreatePostCommentCommand?
    var result: Result<Comment, Error>?

    func execute(_ command: CreatePostCommentCommand) async throws -> Comment {
        receivedCommand = command
        guard let result else {
            fatalError("MockCreatePostCommentUseCase.result not set")
        }
        return try result.get()
    }
}
