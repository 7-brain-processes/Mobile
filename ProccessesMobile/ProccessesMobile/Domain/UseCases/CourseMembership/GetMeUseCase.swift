//
//  GetMeUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GetMeUseCase: Sendable {
    func execute() async throws -> User
}