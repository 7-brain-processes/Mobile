//
//  DefaultDeletePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct DefaultDeletePostUseCase: DeletePostUseCase, Sendable {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, postId: UUID) async throws {
        try await repository.deletePost(courseId: courseId, postId: postId)
    }
}
