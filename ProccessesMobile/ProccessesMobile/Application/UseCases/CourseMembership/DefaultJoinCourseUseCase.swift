//
//  DefaultJoinCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultJoinCourseUseCase: JoinCourseUseCase {

    private let repository: CourseMembershipRepository

    init(repository: CourseMembershipRepository) {
        self.repository = repository
    }

    func execute(_ command: JoinCourseCodeCommand) async throws -> Course {

        let code = command.code.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !code.isEmpty else {
            throw MembershipValidationError.emptyInviteCode
        }

        let sanitized = JoinCourseCodeCommand(code: code)

        return try await repository.joinCourse(sanitized)
    }
}
