//
//  MockGetMeUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct MockGetMeUseCase: GetMeUseCase {
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> User {
        // No input to validate, just delegate to the repository
        return try await repository.getMe()
    }
}