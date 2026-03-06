//
//  MockDeleteSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct MockDeleteSolutionUseCase: DeleteSolutionUseCase {
    let repo: SolutionRepository
    public func execute(courseId: String, postId: String, solutionId: String) async throws {
        try validateIds(courseId: courseId, postId: postId, solutionId: solutionId)
        try await repo.deleteSolution(courseId: courseId, postId: postId, solutionId: solutionId)
    }
}