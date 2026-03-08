//
//  AuthRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol AuthRepository: Sendable {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterRequest) async throws -> AuthResponse
    func getMe() async throws -> User
}
