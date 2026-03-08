//
//  MockCreateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockCreateCourseUseCase: CreateCourseUseCase {
    private(set) var receivedCommand: CreateCourseCommand?
    var result: Result<Course, Error>?

    func execute(_ command: CreateCourseCommand) async throws -> Course {
        receivedCommand = command

        guard let result else {
            fatalError("MockCreateCourseUseCase.result was not set")
        }

        return try result.get()
    }
}
