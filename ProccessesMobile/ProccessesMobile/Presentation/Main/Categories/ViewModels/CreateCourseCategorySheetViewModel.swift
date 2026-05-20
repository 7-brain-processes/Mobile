//
//  CreateCourseCategoryViewModel.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation
import Combine

@MainActor
final class CreateCourseCategorySheetViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var isActive = true

    @Published private(set) var isSubmitting = false
    @Published private(set) var errorMessage: String?

    private let courseId: UUID
    private let createCourseCategoryUseCase: CreateCourseCategoryUseCase
    private let onCreated: @MainActor () async -> Void

    init(
        courseId: UUID,
        createCourseCategoryUseCase: CreateCourseCategoryUseCase,
        onCreated: @escaping @MainActor () async -> Void
    ) {
        self.courseId = courseId
        self.createCourseCategoryUseCase = createCourseCategoryUseCase
        self.onCreated = onCreated
    }

    var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    func save() async {
        guard !isSaveDisabled else { return }

        isSubmitting = true
        errorMessage = nil

        let request = CreateCourseCategoryRequest(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            isActive: isActive
        )

        do {
            _ = try await createCourseCategoryUseCase.execute(
                courseId: courseId,
                request: request
            )

            await onCreated()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmitting = false
    }
}
