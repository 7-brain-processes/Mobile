//
//  EditCourseCategorySheetViewModel.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation
import Combine

@MainActor
final class EditCourseCategorySheetViewModel: ObservableObject {
    @Published var title: String
    @Published var description: String
    @Published var isActive: Bool

    @Published private(set) var isSubmitting = false
    @Published private(set) var errorMessage: String?

    private let courseId: UUID
    private let categoryId: UUID
    private let updateCourseCategoryUseCase: UpdateCourseCategoryUseCase
    private let onUpdated: @MainActor () async -> Void

    init(
        courseId: UUID,
        category: CourseCategory,
        updateCourseCategoryUseCase: UpdateCourseCategoryUseCase,
        onUpdated: @escaping @MainActor () async -> Void
    ) {
        self.courseId = courseId
        self.categoryId = category.id
        self.title = category.title
        self.description = category.description
        self.isActive = category.isActive
        self.updateCourseCategoryUseCase = updateCourseCategoryUseCase
        self.onUpdated = onUpdated
    }

    var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    func save() async {
        guard !isSaveDisabled else { return }

        isSubmitting = true
        errorMessage = nil

        let request = UpdateCourseCategoryRequest(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            isActive: isActive
        )

        do {
            _ = try await updateCourseCategoryUseCase.execute(
                courseId: courseId,
                categoryId: categoryId,
                request: request
            )
            await onUpdated()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmitting = false
    }
}