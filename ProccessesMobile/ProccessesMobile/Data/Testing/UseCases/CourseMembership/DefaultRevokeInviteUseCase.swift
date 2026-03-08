//
//  DefaultRevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultRevokeInviteUseCase: RevokeInviteUseCase {
    private let repository: CourseInvitesRepository

    init(repository: CourseInvitesRepository) {
        self.repository = repository
    }

    func execute(_ command: RevokeInviteCommand) async throws {
        try await repository.revokeInvite(command)
    }
}