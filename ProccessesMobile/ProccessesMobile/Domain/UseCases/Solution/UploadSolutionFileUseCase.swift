//
//  UploadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol UploadSolutionFileUseCase: Sendable {
    func execute(_ command: UploadSolutionFileCommand) async throws -> AttachedFile
}
