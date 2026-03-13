//
//  DefaultGetSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct DefaultGetSolutionUseCase: GetSolutionUseCase, Sendable {
    private let repository: SolutionRepository

    init(repository: SolutionRepository) {
        self.repository = repository
    }

    func execute(
        courseId: UUID,
        postId: UUID,
        solutionId: UUID
    ) async throws -> Solution {
        try await repository.getSolution(
            SolutionOfPost(
                courseId: courseId,
                postId: postId,
                solutionId: solutionId
            )
        )
    }
}
