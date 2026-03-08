//
//  MockLeaveCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockLeaveCourseUseCase: LeaveCourseUseCase {
    private(set) var receivedCommand: LeaveCourseCommand?
    var result: Result<Void, Error>?

    func execute(_ command: LeaveCourseCommand) async throws {
        receivedCommand = command

        guard let result else {
            fatalError("MockLeaveCourseUseCase.result was not set")
        }

        _ = try result.get()
    }
}
