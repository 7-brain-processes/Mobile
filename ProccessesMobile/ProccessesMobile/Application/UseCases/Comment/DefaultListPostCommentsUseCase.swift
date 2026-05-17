//
//  DefaultListPostCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

struct DefaultListPostCommentsUseCase: ListPostCommentsUseCase {
    private let repository: PostCommentsRepository

    init(repository: PostCommentsRepository) {
        self.repository = repository
    }

    func execute(_ query: ListPostCommentsQuery) async throws -> Page<Comment> {
        let normalized = ListPostCommentsQuery(
            courseId: query.courseId,
            postId: query.postId,
            page: max(0, query.page),
            size: min(max(1, query.size), 100)
        )

        return try await repository.listComments(normalized)
    }
}