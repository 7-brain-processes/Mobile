//
//  DefaultSetMyCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 04.05.2026.
//

import Foundation

final class DefaultSetMyCourseCategoryUseCase: SetMyCourseCategoryUseCase, Sendable {
    private let repository: CourseCategoriesRepository

    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID, categoryId: UUID?) async throws -> CourseCategory? {
        try await repository.setMyCategory(
            courseId: courseId,
            categoryId: categoryId
        )
    }
}
