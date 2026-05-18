//
//  DefaultUpdateCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import Foundation

final class DefaultUpdateCourseCategoryUseCase: UpdateCourseCategoryUseCase, Sendable {
    private let repository: CourseCategoriesRepository

    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(
        courseId: UUID,
        categoryId: UUID,
        request: UpdateCourseCategoryRequest
    ) async throws -> CourseCategory {
        try await repository.updateCourseCategory(
            courseId: courseId,
            categoryId: categoryId,
            request: request
        )
    }
}
