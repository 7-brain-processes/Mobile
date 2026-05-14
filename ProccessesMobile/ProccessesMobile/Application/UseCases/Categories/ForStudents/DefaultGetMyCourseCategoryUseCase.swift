//
//  DefaultGetMyCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 04.05.2026.
//

import Foundation

final class DefaultGetMyCourseCategoryUseCase: GetMyCourseCategoryUseCase {
    private let repository: CourseCategoriesRepository
    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID) async throws -> CourseCategory? {
        try await repository.getMyCategory(courseId: courseId)
    }
}
