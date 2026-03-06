//
//  MockListSolutionCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockListSolutionCommentsUseCase: ListSolutionCommentsUseCase {
    let repo: SolutionCommentsRepository
    public func execute(courseId: String, postId: String, solutionId: String, page: Int, size: Int) async throws -> PageComment {
        guard !solutionId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("solutionId") }
        return try await repo.listComments(courseId: courseId, postId: postId, solutionId: solutionId, page: max(0, page), size: min(max(1, size), 100))
    }
}
