//
//  CourseCategoriesRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol CourseCategoriesRepository: Sendable {
    func listCourseCategories(courseId: UUID) async throws -> [CourseCategory]

    func createCourseCategory(
        courseId: UUID,
        request: CreateCourseCategoryRequest
    ) async throws -> CourseCategory

    func updateCourseCategory(
        courseId: UUID,
        categoryId: UUID,
        request: UpdateCourseCategoryRequest
    ) async throws -> CourseCategory

    func deleteCourseCategory(
        courseId: UUID,
        categoryId: UUID
    ) async throws
}
