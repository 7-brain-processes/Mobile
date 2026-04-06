//
//  DefaultListSolutionFilesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultListSolutionFilesUseCase: ListSolutionFilesUseCase {
    private let repository: SolutionFilesRepository

    init(repository: SolutionFilesRepository) {
        self.repository = repository
    }

    func execute(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile] {
        try await repository.listSolutionFiles(query)
    }
}