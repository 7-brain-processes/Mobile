//
//  GradeSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol GradeSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, request: GradeRequest) async throws -> Solution
}