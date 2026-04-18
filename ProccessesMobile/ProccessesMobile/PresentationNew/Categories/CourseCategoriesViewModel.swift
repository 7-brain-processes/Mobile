//
//  CourseCategoriesViewModel.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation
import Combine

@MainActor
final class CourseCategoriesViewModel: ObservableObject {
    @Published private(set) var categories: [CourseCategory] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let courseId: UUID
    private let listCourseCategoriesUseCase: ListCourseCategoriesUseCase

    init(
        courseId: UUID,
        listCourseCategoriesUseCase: ListCourseCategoriesUseCase
    ) {
        self.courseId = courseId
        self.listCourseCategoriesUseCase = listCourseCategoriesUseCase
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            categories = try await listCourseCategoriesUseCase.execute(courseId: courseId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
