//
//  FakeLoginUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct FakeLoginUseCase: LoginUseCase, Sendable {
    let repository: AuthRepository
    let tokenStorage: TokenStorage
    
    func execute(request: LoginRequest) async throws -> AuthResponse {
        guard !request.username.isEmpty, !request.password.isEmpty else {
            throw AuthValidationError.emptyCredentials
        }
        
        let response = try await repository.login(request: request)
        
        try tokenStorage.saveToken(response.token)
        
        return response
    }
}
