//
//  TokenRefreshService.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


protocol TokenRefreshService: Sendable {
    func refreshToken() async throws -> AuthResponse
}