//
//  MockDeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct MockDeleteCourseUseCase: DeleteCourseUseCase {
    private let repository: CourseDetailsRepository
    public init(repository: CourseDetailsRepository) { self.repository = repository }
    
    public func execute(courseId: String) async throws {
        try await repository.deleteCourse(courseId: courseId)
    }
}