//
//  DefaultDownloadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultDownloadSolutionFileUseCase: DownloadSolutionFileUseCase {
    private let repository: SolutionFilesRepository

    init(repository: SolutionFilesRepository) {
        self.repository = repository
    }

    func execute(_ query: DownloadSolutionFileQuery) async throws -> Data {
        try await repository.downloadSolutionFile(query)
    }
}