//
//  DefaultDeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

struct DefaultDeleteCourseUseCase: DeleteCourseUseCase {
    
    private let repository: CourseDetailsRepository
    init(repository: CourseDetailsRepository) { self.repository = repository }
    
    func execute(_ query: DeleteCourseQuery) async throws {
        try await repository.deleteCourse(query)
    }
}
