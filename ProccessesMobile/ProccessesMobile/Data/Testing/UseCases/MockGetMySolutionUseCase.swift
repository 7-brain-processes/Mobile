//
//  MockGetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct MockGetMySolutionUseCase: GetMySolutionUseCase {
    let repo: SolutionRepository
    public func execute(courseId: String, postId: String) async throws -> Solution {
        try validateIds(courseId: courseId, postId: postId)
        return try await repo.getMySolution(courseId: courseId, postId: postId)
    }
}