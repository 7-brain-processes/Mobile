//
//  DeleteSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol DeleteSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String) async throws
}