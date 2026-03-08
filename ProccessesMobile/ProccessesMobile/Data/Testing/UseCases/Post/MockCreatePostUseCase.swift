//
//  MockCreatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockCreatePostUseCase: CreatePostUseCase {
    private(set) var receivedCommand: CreatePostCommand?
    var result: Result<Post, Error>?

    func execute(_ command: CreatePostCommand) async throws -> Post {
        receivedCommand = command

        guard let result else {
            fatalError("MockCreatePostUseCase.result was not set")
        }

        return try result.get()
    }
}
