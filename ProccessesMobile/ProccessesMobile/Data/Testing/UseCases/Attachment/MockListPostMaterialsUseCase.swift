//
//  MockListPostMaterialsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockListPostMaterialsUseCase: ListPostMaterialsUseCase {
    private(set) var receivedQuery: ListPostMaterialsQuery?
    var result: Result<[AttachedFile], Error>?

    func execute(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile] {
        receivedQuery = query

        guard let result else {
            fatalError("MockListPostMaterialsUseCase.result was not set")
        }

        return try result.get()
    }
}
