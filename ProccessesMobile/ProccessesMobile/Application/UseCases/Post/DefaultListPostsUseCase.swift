//
//  DefaultListPostsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultListPostsUseCase: ListPostsUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func execute(_ query: ListPostsQuery) async throws -> Page<Post> {
        let normalized = ListPostsQuery(
            courseId: query.courseId,
            page: max(0, query.page),
            size: min(max(1, query.size), 100),
            type: query.type
        )

        return try await repository.listPosts(normalized)
    }
}
