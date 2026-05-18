//
//  DefaultDeleteCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import Foundation

final class DefaultDeleteCourseCategoryUseCase: DeleteCourseCategoryUseCase, Sendable {
    private let repository: CourseCategoriesRepository

    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(
        courseId: UUID,
        categoryId: UUID
    ) async throws {
        try await repository.deleteCourseCategory(
            courseId: courseId,
            categoryId: categoryId
        )
    }
}
