//
//  MockListPostsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockListPostsUseCase: ListPostsUseCase {
    private(set) var receivedQuery: ListPostsQuery?
    var result: Result<Page<Post>, Error>?

    func execute(_ query: ListPostsQuery) async throws -> Page<Post> {
        receivedQuery = query

        guard let result else {
            fatalError("MockListPostsUseCase.result was not set")
        }

        return try result.get()
    }
}
