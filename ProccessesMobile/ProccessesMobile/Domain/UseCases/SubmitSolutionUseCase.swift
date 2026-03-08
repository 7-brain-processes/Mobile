//
//  SubmitSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol SubmitSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution
}
