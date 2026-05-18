//
//  GetMyCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 04.05.2026.
//

import Foundation

protocol GetMyCourseCategoryUseCase {
    func execute(courseId: UUID) async throws -> CourseCategory?
}
