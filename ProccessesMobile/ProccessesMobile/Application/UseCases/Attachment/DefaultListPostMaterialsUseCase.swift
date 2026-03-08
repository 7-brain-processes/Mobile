//
//  DefaultListPostMaterialsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultListPostMaterialsUseCase: ListPostMaterialsUseCase {
    private let repository: PostMaterialsRepository

    init(repository: PostMaterialsRepository) {
        self.repository = repository
    }

    func execute(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile] {
        try await repository.listMaterials(query)
    }
}