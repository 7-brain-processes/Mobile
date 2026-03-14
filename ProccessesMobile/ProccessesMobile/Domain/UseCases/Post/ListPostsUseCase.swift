//
//  ListPostsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol ListPostsUseCase: Sendable {
    func execute(_ query: ListPostsQuery) async throws -> Page<Post>
}
