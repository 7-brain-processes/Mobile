//
//  DefaultUploadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultUploadSolutionFileUseCase: UploadSolutionFileUseCase {
    private let repository: SolutionFilesRepository

    init(repository: SolutionFilesRepository) {
        self.repository = repository
    }

    func execute(_ command: UploadSolutionFileCommand) async throws -> AttachedFile {
        guard !command.data.isEmpty else {
            throw FileValidationError.emptyFileData
        }

        return try await repository.uploadSolutionFile(command)
    }
}
