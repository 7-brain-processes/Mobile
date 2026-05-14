//
//  DefaultListCourseCategoriesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

final class DefaultListCourseCategoriesUseCase: ListCourseCategoriesUseCase, Sendable {
    private let repository: CourseCategoriesRepository

    init(repository: CourseCategoriesRepository) {
        self.repository = repository
    }

    func execute(courseId: UUID) async throws -> [CourseCategory] {
        try await repository.listCourseCategories(courseId: courseId)
    }
}