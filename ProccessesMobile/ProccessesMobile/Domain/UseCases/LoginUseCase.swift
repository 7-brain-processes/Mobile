//
//  LoginUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol LoginUseCase: Sendable {
    func execute(request: LoginRequest) async throws -> AuthResponse
}
