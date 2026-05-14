//
//  ListCourseCategoriesUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol ListCourseCategoriesUseCase: Sendable {
    func execute(courseId: UUID) async throws -> [CourseCategory]
}