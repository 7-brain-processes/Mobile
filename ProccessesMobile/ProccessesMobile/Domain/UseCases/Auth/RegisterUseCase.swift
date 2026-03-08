//
//  RegisterUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol RegisterUseCase: Sendable {
    func execute(_ command: RegisterCommand) async throws -> AuthResponse
}
