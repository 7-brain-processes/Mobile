//
//  DefaultLeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultLeaveCourseUseCase: LeaveCourseUseCase {
    private let repository: CourseMembershipRepository

    init(repository: CourseMembershipRepository) {
        self.repository = repository
    }

    func execute(_ command: LeaveCourseCommand) async throws {
        try await repository.leaveCourse(command)
    }
}
