//
//  MockUpdatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockUpdatePostUseCase: UpdatePostUseCase {
    private(set) var receivedCommand: UpdatePostCommand?
    var result: Result<Post, Error>?

    func execute(_ command: UpdatePostCommand) async throws -> Post {
        receivedCommand = command

        guard let result else {
            fatalError("MockUpdatePostUseCase.result was not set")
        }

        return try result.get()
    }
}
