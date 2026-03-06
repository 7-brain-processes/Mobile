//
//  UpdateSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//



public protocol UpdateSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest) async throws -> Solution
}