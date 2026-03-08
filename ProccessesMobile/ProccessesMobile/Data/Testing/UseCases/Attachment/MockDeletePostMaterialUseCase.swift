//
//  MockDeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockDeletePostMaterialUseCase: DeletePostMaterialUseCase {
    private(set) var receivedCommand: DeletePostMaterialCommand?
    var error: Error?

    func execute(_ command: DeletePostMaterialCommand) async throws {
        receivedCommand = command

        if let error {
            throw error
        }
    }
}
