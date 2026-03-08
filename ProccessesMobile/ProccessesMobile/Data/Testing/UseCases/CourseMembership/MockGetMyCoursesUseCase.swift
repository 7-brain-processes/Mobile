//
//  MockGetMyCoursesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

final class MockGetMyCoursesUseCase: GetMyCoursesUseCase {
    private(set) var receivedQuery: GetMyCoursesQuery?
    var result: Result<Page<Course>, Error>?

    func execute(_ query: GetMyCoursesQuery) async throws -> Page<Course> {
        receivedQuery = query

        guard let result else {
            fatalError("MockGetMyCoursesUseCase.result was not set")
        }

        return try result.get()
    }
}
