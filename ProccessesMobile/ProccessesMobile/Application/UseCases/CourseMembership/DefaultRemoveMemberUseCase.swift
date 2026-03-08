//
//  DefaultRemoveMemberUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultRemoveMemberUseCase: RemoveMemberUseCase {
    private let repository: CourseMembersRepository

    init(repository: CourseMembersRepository) {
        self.repository = repository
    }

    func execute(_ command: RemoveMemberCommand) async throws {
        try await repository.removeMember(command)
    }
}