//
//  DefaultLoginUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public final class DefaultLoginUseCase: LoginUseCase {
    private let repository: AuthRepository
    private let tokenStorage: TokenStorage
    
    public init(repository: AuthRepository, tokenStorage: TokenStorage) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }
    
    public func execute(request: LoginRequest) async throws -> AuthResponse {
        guard !request.username.isEmpty, !request.password.isEmpty else {
            throw AuthValidationError.emptyCredentials
        }
        
        let response = try await repository.login(request: request)
        try tokenStorage.saveToken(response.token)
        return response
    }
}
