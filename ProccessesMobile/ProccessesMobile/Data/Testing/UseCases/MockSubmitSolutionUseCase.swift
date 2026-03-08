//
//  MockSubmitSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockSubmitSolutionUseCase: SubmitSolutionUseCase {
    let repo: SolutionRepository
    func execute(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution {
        try validateIds(courseId: courseId, postId: postId)
        let sanitized = try validateAndSanitize(request: request)
        return try await repo.submitSolution(courseId: courseId, postId: postId, request: sanitized)
    }
}