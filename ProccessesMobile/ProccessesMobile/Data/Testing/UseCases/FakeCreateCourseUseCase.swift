//
//  MockCreateCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct FakeCreateCourseUseCase: CreateCourseUseCase {
    let repository: CourseRepository
    
    func execute(request: CreateCourseRequest) async throws -> Course {
        guard request.name.count >= 1 && request.name.count <= 200 else {
            throw CourseValidationError.invalidNameLength(min: 1, max: 200)
        }
        
        if let desc = request.description, desc.count > 2000 {
            throw CourseValidationError.invalidDescriptionLength(max: 2000)
        }
        
        return try await repository.createCourse(request: request)
    }
}
