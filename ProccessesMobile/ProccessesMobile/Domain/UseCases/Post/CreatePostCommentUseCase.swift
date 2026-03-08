//
//  CreatePostCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol CreatePostCommentUseCase: Sendable {
    func execute(_ command: CreatePostCommentCommand) async throws -> Comment
}
