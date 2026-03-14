//
//  DefaultListSolutionsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultListSolutionsUseCase: ListSolutionsUseCase {
    private let repository: SolutionRepository

    init(repository: SolutionRepository) {
        self.repository = repository
    }

    func execute(_ query: ListSolutionsQuery) async throws -> Page<Solution> {
        let normalized = ListSolutionsQuery(
            courseId: query.courseId,
            postId: query.postId,
            page: max(0, query.page),
            size: min(max(1, query.size), 100),
            status: query.status
        )

        return try await repository.listSolutions(normalized)
    }
}
