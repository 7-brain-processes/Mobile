//
//  UpdatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol UpdatePostUseCase: Sendable {
    func execute(_ command: UpdatePostCommand) async throws -> Post
}

