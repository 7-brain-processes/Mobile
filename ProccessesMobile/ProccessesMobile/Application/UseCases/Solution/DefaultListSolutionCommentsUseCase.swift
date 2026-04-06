//
//  DefaultListSolutionCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultListSolutionCommentsUseCase: ListSolutionCommentsUseCase {
    private let repository: SolutionCommentsRepository

    init(repository: SolutionCommentsRepository) {
        self.repository = repository
    }

    func execute(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment> {
        let normalized = ListSolutionCommentsQuery(
            courseId: query.courseId,
            postId: query.postId,
            solutionId: query.solutionId,
            page: max(0, query.page),
            size: min(max(1, query.size), 100)
        )

        return try await repository.listComments(normalized)
    }
}