//
//  UpdateCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol UpdateCourseCategoryUseCase: Sendable {
    func execute(
        courseId: UUID,
        categoryId: UUID,
        request: UpdateCourseCategoryRequest
    ) async throws -> CourseCategory
}
