//
//  DefaultCreateCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

final class DefaultCreateCourseCategoryUseCase: CreateCourseCategoryUseCase, Sendable {
    private let repository: CourseCategoriesRepository

    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(
        courseId: UUID,
        request: CreateCourseCategoryRequest
    ) async throws -> CourseCategory {
        try await repository.createCourseCategory(
            courseId: courseId,
            request: request
        )
    }
}