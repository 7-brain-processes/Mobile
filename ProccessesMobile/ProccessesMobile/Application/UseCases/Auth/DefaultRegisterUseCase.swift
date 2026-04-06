//
//  DefaultRegisterUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class DefaultRegisterUseCase: RegisterUseCase {
    private let repository: AuthRepository
    private let tokenStorage: TokenStorage

    init(repository: AuthRepository, tokenStorage: TokenStorage) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }

    func execute(_ command: RegisterCommand) async throws -> AuthResponse {
        guard command.username.count >= 3 && command.username.count <= 50 else {
            throw AuthValidationError.usernameInvalidLength(min: 3, max: 50)
        }

        guard command.password.count >= 6 && command.password.count <= 128 else {
            throw AuthValidationError.passwordInvalidLength(min: 6, max: 128)
        }

        let response = try await repository.register(request: command)
        try tokenStorage.saveToken(response.token)
        return response
    }
}
