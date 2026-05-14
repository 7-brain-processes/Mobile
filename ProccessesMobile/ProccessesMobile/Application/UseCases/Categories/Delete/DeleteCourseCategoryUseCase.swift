//
//  DeleteCourseCategoryUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol DeleteCourseCategoryUseCase: Sendable {
    func execute(
        courseId: UUID,
        categoryId: UUID
    ) async throws
}
