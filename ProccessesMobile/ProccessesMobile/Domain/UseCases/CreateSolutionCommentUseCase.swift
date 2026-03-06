//
//  CreateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CreateSolutionCommentUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, request: CreateCommentRequest) async throws -> Comment
}