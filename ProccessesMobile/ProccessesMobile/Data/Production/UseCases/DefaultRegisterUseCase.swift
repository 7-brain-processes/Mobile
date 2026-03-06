//
//  DefaultRegisterUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public final class DefaultRegisterUseCase: RegisterUseCase {
    private let repository: AuthRepository
    private let tokenStorage: TokenStorage
    
    public init(repository: AuthRepository, tokenStorage: TokenStorage) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }
    
    public func execute(request: RegisterRequest) async throws -> AuthResponse {
        guard request.username.count >= 3 && request.username.count <= 50 else {
            throw AuthValidationError.usernameInvalidLength(min: 3, max: 50)
        }
        
        guard request.password.count >= 6 && request.password.count <= 128 else {
            throw AuthValidationError.passwordInvalidLength(min: 6, max: 128)
        }
        
        let response = try await repository.register(request: request)
        try tokenStorage.saveToken(response.token)
        return response
    }
}
