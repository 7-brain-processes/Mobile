//
//  LoginUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol LoginUseCase: Sendable {
    func execute(_ command: LoginCommand) async throws -> AuthResponse
}
