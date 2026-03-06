//
//  RegisterUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol RegisterUseCase: Sendable {
    func execute(request: RegisterRequest) async throws -> AuthResponse
}
