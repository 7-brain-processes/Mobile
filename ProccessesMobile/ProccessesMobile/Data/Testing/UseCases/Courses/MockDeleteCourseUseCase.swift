//
//  MockDeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockDeleteCourseUseCase: DeleteCourseUseCase {
    
    private let repository: CourseDetailsRepository
    init(repository: CourseDetailsRepository) { self.repository = repository }
    
    func execute(_ query: DeleteCourseQuery) async throws {
        try await repository.deleteCourse(query)
    }
}
