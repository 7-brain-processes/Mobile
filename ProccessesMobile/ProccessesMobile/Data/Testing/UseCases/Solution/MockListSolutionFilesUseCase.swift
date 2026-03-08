//
//  MockListSolutionFilesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockListSolutionFilesUseCase: ListSolutionFilesUseCase {
    private(set) var receivedQuery: ListSolutionFilesQuery?
    var result: Result<[AttachedFile], Error>?

    func execute(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile] {
        receivedQuery = query

        guard let result else {
            fatalError("MockListSolutionFilesUseCase.result was not set")
        }

        return try result.get()
    }
}
