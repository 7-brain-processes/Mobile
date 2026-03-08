//
//  DefaultGetMyCoursesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

struct DefaultGetMyCoursesUseCase: GetMyCoursesUseCase {
    let repository: CourseRepository

    func execute(_ query: GetMyCoursesQuery) async throws -> Page<Course> {
        let normalizedQuery = GetMyCoursesQuery(
            page: max(0, query.page),
            size: min(max(1, query.size), 100),
            role: query.role
        )

        return try await repository.getMyCourses(normalizedQuery)
    }
}
