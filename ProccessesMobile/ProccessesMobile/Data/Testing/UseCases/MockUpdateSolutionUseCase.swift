//
//  MockUpdateSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockUpdateSolutionUseCase: UpdateSolutionUseCase {
    let repo: SolutionRepository
    func execute(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest) async throws -> Solution {
        try validateIds(courseId: courseId, postId: postId, solutionId: solutionId)
        let sanitized = try validateAndSanitize(request: request)
        return try await repo.updateSolution(courseId: courseId, postId: postId, solutionId: solutionId, request: sanitized)
    }
}