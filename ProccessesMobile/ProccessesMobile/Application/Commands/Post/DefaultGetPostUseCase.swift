//
//  DefaultGetPostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct DefaultGetPostUseCase: GetPostUseCase, Sendable {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID) async throws -> Post {
        try await repository.getPost(courseId: courseId, postId: postId)
    }
}
