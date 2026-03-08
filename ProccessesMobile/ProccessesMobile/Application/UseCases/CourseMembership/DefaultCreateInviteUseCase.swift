//
//  DefaultCreateInviteUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultCreateInviteUseCase: CreateInviteUseCase {
    private let repository: CourseInvitesRepository

    init(repository: CourseInvitesRepository) {
        self.repository = repository
    }

    func execute(_ command: CreateInviteCommand) async throws -> Invite {
        if let maxUses = command.maxUses, maxUses < 1 {
            throw CourseUsersValidationError.invalidMaxUses(minimum: 1)
        }

        return try await repository.createInvite(command)
    }
}