//
//  MockUploadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockUploadPostMaterialUseCase: UploadPostMaterialUseCase {
    private(set) var receivedCommand: UploadPostMaterialCommand?
    var result: Result<AttachedFile, Error>?

    func execute(_ command: UploadPostMaterialCommand) async throws -> AttachedFile {
        receivedCommand = command

        guard let result else {
            fatalError("MockUploadPostMaterialUseCase.result was not set")
        }

        return try result.get()
    }
}
