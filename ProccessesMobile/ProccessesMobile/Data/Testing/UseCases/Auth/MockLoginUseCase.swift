//
//  MockLoginUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockLoginUseCase: LoginUseCase {
    private(set) var receivedCommand: LoginCommand?
    var result: Result<AuthResponse, Error>?

    func execute(_ command: LoginCommand) async throws -> AuthResponse {
        receivedCommand = command

        guard let result else {
            fatalError("MockLoginUseCase.result was not set")
        }

        return try result.get()
    }
}
