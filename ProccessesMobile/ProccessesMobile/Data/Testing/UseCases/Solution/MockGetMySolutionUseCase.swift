//
//  MockGetMySolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockGetMySolutionUseCase: GetMySolutionUseCase {
    private(set) var receivedQuery: GetMySolutionQuery?
    var result: Result<Solution, Error>?

    func execute(_ query: GetMySolutionQuery) async throws -> Solution {
        receivedQuery = query

        guard let result else {
            fatalError("MockGetMySolutionUseCase.result was not set")
        }

        return try result.get()
    }
}
