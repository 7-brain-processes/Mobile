//
//  MockDeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockDeleteCourseUseCase: DeleteCourseUseCase {
    private let repository: CourseDetailsRepository
    init(repository: CourseDetailsRepository) { self.repository = repository }
    
    func execute(courseId: String) async throws {
        try await repository.deleteCourse(courseId: courseId)
    }
}