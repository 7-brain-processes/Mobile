//
//  MockGetMyCoursesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct FakeGetMyCoursesUseCase: GetMyCoursesUseCase {
    let repository: CourseRepository
    
    func execute(page: Int, size: Int, role: CourseRole?) async throws -> PageCourse {
        let safePage = max(0, page)
        let safeSize = min(max(1, size), 100)
        
        return try await repository.getMyCourses(page: safePage, size: safeSize, role: role)
    }
}
