//
//  GetSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol GetSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String) async throws -> Solution
}