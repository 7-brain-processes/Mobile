//
//  CourseCategoriesRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol CourseCategoriesRepository: Sendable {
    func listCourseCategories(courseId: UUID) async throws -> [CourseCategory]
}