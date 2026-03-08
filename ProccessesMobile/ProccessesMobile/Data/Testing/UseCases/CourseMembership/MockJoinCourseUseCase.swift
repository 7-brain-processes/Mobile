//
//  MockJoinCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockJoinCourseUseCase: JoinCourseUseCase {
    private(set) var receivedCommand: JoinCourseCodeCommand?
    var result: Result<Course, Error>?

    func execute(_ command: JoinCourseCodeCommand) async throws -> Course {
        receivedCommand = command

        guard let result else {
            fatalError("MockJoinCourseUseCase.result was not set")
        }

        return try result.get()
    }
}
