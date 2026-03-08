//
//  ListPostsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol ListPostsUseCase: Sendable {
    func execute(courseId: String, page: Int, size: Int, type: PostType?) async throws -> PagePost
}