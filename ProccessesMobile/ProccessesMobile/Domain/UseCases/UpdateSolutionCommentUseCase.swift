//
//  UpdateSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol UpdateSolutionCommentUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment
}