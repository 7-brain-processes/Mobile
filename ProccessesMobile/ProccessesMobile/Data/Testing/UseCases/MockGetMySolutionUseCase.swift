//
//  MockGetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockGetMySolutionUseCase: GetMySolutionUseCase {
    let repo: SolutionRepository
    func execute(courseId: String, postId: String) async throws -> Solution {
        try validateIds(courseId: courseId, postId: postId)
        return try await repo.getMySolution(courseId: courseId, postId: postId)
    }
}