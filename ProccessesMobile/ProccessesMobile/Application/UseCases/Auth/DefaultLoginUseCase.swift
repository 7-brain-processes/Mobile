//
//  DefaultLoginUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

final class DefaultLoginUseCase: LoginUseCase {
    private let repository: AuthRepository
    private let tokenStorage: TokenStorage
    
    init(repository: AuthRepository, tokenStorage: TokenStorage) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }
    
    func execute(_ command: LoginCommand) async throws -> AuthResponse{
        guard !command.username.isEmpty, !command.password.isEmpty else {
            throw AuthValidationError.emptyCredentials
        }
        
        let response = try await repository.login(request: command)
        try tokenStorage.saveToken(response.token)
        return response
    }
}
