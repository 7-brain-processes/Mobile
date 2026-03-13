//
//  ReloginService.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


protocol ReloginService: Sendable {
    func relogin() async throws -> AuthResponse
}