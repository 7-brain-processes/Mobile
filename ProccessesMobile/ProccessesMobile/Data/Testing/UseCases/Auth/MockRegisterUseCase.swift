//
//  MockRegisterUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


final class MockRegisterUseCase: RegisterUseCase {
    private(set) var receivedCommand: RegisterCommand?
    var result: Result<AuthResponse, Error>?

    func execute(_ command: RegisterCommand) async throws -> AuthResponse {
        receivedCommand = command

        guard let result else {
            fatalError("MockRegisterUseCase.result was not set")
        }

        return try result.get()
    }
}