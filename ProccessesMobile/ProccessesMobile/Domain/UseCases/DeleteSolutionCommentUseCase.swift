//
//  DeleteSolutionCommentUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol DeleteSolutionCommentUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, commentId: String) async throws
}