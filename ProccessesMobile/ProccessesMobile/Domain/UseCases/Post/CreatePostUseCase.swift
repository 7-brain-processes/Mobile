//
//  CreatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol CreatePostUseCase: Sendable {
    func execute(_ command: CreatePostCommand) async throws -> Post
}
