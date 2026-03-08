//
//  MockUploadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockUploadSolutionFileUseCase: UploadSolutionFileUseCase {
    private(set) var receivedCommand: UploadSolutionFileCommand?
    var result: Result<AttachedFile, Error>?

    func execute(_ command: UploadSolutionFileCommand) async throws -> AttachedFile {
        receivedCommand = command

        guard let result else {
            fatalError("MockUploadSolutionFileUseCase.result was not set")
        }

        return try result.get()
    }
}
