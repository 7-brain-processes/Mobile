//
//  MockListSolutionsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockListSolutionsUseCase: ListSolutionsUseCase {
    private(set) var receivedQuery: ListSolutionsQuery?
    var result: Result<Page<Solution>, Error>?

    func execute(_ query: ListSolutionsQuery) async throws -> Page<Solution> {
        receivedQuery = query

        guard let result else {
            fatalError("MockListSolutionsUseCase.result was not set")
        }

        return try result.get()
    }
}
