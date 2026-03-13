//
//  DefaultDownloadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import Foundation

struct DefaultDownloadPostMaterialUseCase: DownloadPostMaterialUseCase, Sendable {
    private let repository: PostMaterialsRepository

    init(repository: PostMaterialsRepository) {
        self.repository = repository
    }

    func execute(_ query: DownloadPostMaterialQuery) async throws -> Data {
        try await repository.downloadMaterial(query)
    }
}
