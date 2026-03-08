//
//  MockDownloadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockDownloadPostMaterialUseCase: DownloadPostMaterialUseCase {
    private(set) var receivedQuery: DownloadPostMaterialQuery?

    var result: Result<Data, Error>?

    func execute(_ command: DownloadPostMaterialQuery) async throws -> Data {
        receivedQuery = command
        guard let result else {
            fatalError("MockDownloadPostMaterialUseCase.result was not set")
        }
        return try result.get()
    }
}
