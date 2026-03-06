//
//  SubmitSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol SubmitSolutionUseCase: Sendable {
    func execute(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution
}
