//
//  MockUpdateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct MockUpdateCourseUseCase: UpdateCourseUseCase {
    private let repository: CourseDetailsRepository
    init(repository: CourseDetailsRepository) { self.repository = repository }
    
    func execute(courseId: String, request: UpdateCourseRequest) async throws -> Course {
        if let name = request.name {
            guard name.count >= 1 && name.count <= 200 else {
                throw CourseValidationError.invalidNameLength(min: 1, max: 200)
            }
        }
        if let desc = request.description, desc.count > 2000 {
            throw CourseValidationError.invalidDescriptionLength(max: 2000)
        }
        return try await repository.updateCourse(courseId: courseId, request: request)
    }
}
