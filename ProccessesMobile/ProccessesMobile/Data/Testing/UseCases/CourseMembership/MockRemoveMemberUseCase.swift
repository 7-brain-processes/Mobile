//
//  MockRemoveMemberUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockRemoveMemberUseCase: RemoveMemberUseCase {
    private(set) var receivedCommand: RemoveMemberCommand?
    var result: Result<Void, Error>?

    func execute(_ command: RemoveMemberCommand) async throws {
        receivedCommand = command

        guard let result else {
            fatalError("MockRemoveMemberUseCase.result was not set")
        }

        _ = try result.get()
    }
}
