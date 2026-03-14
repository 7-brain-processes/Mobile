//
//  DefaultUploadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultUploadPostMaterialUseCase: UploadPostMaterialUseCase {
    private let repository: PostMaterialsRepository

    init(repository: PostMaterialsRepository) {
        self.repository = repository
    }

    func execute(_ command: UploadPostMaterialCommand) async throws -> AttachedFile {
        guard !command.fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FileValidationError.invalidFileName
        }

        guard !command.data.isEmpty else {
            throw FileValidationError.emptyFileData
        }

        return try await repository.uploadMaterial(command)
    }
}