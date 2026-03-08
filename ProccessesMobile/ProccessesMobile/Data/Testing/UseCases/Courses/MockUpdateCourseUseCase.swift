//
//  MockUpdateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockUpdateCourseUseCase: UpdateCourseUseCase {
    private(set) var receivedCommand: UpdateCourseCommand?
    var result: Result<Course, Error>?

    func execute(_ command: UpdateCourseCommand) async throws -> Course {
        receivedCommand = command

        guard let result else {
            fatalError("MockUpdateCourseUseCase.result was not set")
        }

        return try result.get()
    }
}
