//
//  CreateCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol CreateCourseCategoryUseCase: Sendable {
    func execute(
        courseId: UUID,
        request: CreateCourseCategoryRequest
    ) async throws -> CourseCategory
}