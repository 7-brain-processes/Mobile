//
//  ListSolutionCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol ListSolutionCommentsUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, page: Int, size: Int) async throws -> PageComment
}