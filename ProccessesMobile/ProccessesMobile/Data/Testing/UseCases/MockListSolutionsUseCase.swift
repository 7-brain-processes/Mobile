//
//  MockListSolutionsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockListSolutionsUseCase: ListSolutionsUseCase {
    let repo: SolutionRepository
    func execute(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?) async throws -> PageSolution {
        try validateIds(courseId: courseId, postId: postId)
        return try await repo.listSolutions(courseId: courseId, postId: postId, page: max(0, page), size: min(max(1, size), 100), status: status)
    }
}
