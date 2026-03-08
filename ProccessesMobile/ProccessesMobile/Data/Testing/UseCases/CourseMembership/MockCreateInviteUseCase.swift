//
//  MockCreateInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockCreateInviteUseCase: CreateInviteUseCase {
    private(set) var receivedCommand: CreateInviteCommand?
    var result: Result<Invite, Error>?

    func execute(_ command: CreateInviteCommand) async throws -> Invite {
        receivedCommand = command

        guard let result else {
            fatalError("MockCreateInviteUseCase.result was not set")
        }

        return try result.get()
    }
}
