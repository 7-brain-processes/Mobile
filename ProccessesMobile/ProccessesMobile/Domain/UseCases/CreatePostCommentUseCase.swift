//
//  CreatePostCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CreatePostCommentUseCase: Sendable {
    func execute(courseId: String, postId: String, request: CreateCommentRequest) async throws -> Comment
}
