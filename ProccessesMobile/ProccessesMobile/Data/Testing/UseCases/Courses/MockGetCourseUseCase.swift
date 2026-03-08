//
//  MockGetCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class MockGetCourseUseCase: GetCourseUseCase {
    private(set) var receivedQuery: GetCourseQuery?
    var result: Result<Course, Error>?

    func execute(_ query: GetCourseQuery) async throws -> Course {
        receivedQuery = query

        guard let result else {
            fatalError("MockGetCourseUseCase.result was not set")
        }

        return try result.get()
    }
}
