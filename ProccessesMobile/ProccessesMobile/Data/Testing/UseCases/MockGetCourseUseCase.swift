//
//  MockGetCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockGetCourseUseCase: GetCourseUseCase {
    private let repository: CourseDetailsRepository
    
    init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    func execute(courseId: String) async throws -> Course {
        let trimmedId = courseId.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedId.isEmpty else {
            throw CourseValidationError.emptyCourseId
        }
        
        return try await repository.getCourse(courseId: trimmedId)
    }
}
