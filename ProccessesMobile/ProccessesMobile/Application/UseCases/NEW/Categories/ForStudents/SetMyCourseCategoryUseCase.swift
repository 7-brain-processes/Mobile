//
//  SetMyCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 04.05.2026.
//

import Foundation

protocol SetMyCourseCategoryUseCase {
    func execute(courseId: UUID, categoryId: UUID?) async throws
}
