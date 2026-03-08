//
//  MockRevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockRevokeInviteUseCase: RevokeInviteUseCase {
    private(set) var receivedCommand: RevokeInviteCommand?
    var result: Result<Void, Error>?

    func execute(_ command: RevokeInviteCommand) async throws {
        receivedCommand = command

        guard let result else {
            fatalError("MockRevokeInviteUseCase.result was not set")
        }

        _ = try result.get()
    }
}
