//
//  MockListSolutionCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockListSolutionCommentsUseCase: ListSolutionCommentsUseCase {
    private(set) var receivedQuery: ListSolutionCommentsQuery?
    var result: Result<Page<Comment>, Error>?

    func execute(_ query: ListSolutionCommentsQuery) async throws -> Page<Comment> {
        receivedQuery = query

        guard let result else {
            fatalError("MockListSolutionCommentsUseCase.result was not set")
        }

        return try result.get()
    }
}
