//
//  MockDownloadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockDownloadSolutionFileUseCase: DownloadSolutionFileUseCase {
    private(set) var receivedQuery: DownloadSolutionFileQuery?
    var result: Result<Data, Error>?

    func execute(_ query: DownloadSolutionFileQuery) async throws -> Data {
        receivedQuery = query

        guard let result else {
            fatalError("MockDownloadSolutionFileUseCase.result was not set")
        }

        return try result.get()
    }
}
