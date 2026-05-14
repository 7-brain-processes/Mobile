//
//  CreateTeamRequirementTemplateSheetViewModel.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation
import Combine

@MainActor
final class CreateTeamRequirementTemplateSheetViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var minTeamSize: String = ""
    @Published var maxTeamSize: String = ""
    @Published var selectedCategoryId: UUID?
    @Published var requireAudio: Bool = false
    @Published var requireVideo: Bool = false

    @Published private(set) var categories: [CourseCategory] = []
    @Published private(set) var isLoadingCategories = false
    @Published private(set) var isSubmitting = false
    @Published private(set) var errorMessage: String?

    private let courseId: UUID
    private let listCourseCategoriesUseCase: ListCourseCategoriesUseCase
    private let createTeamRequirementTemplateUseCase: CreateTeamRequirementTemplateUseCase
    private let onCreated: @MainActor (TeamRequirementTemplate) async -> Void

    init(
        courseId: UUID,
        listCourseCategoriesUseCase: ListCourseCategoriesUseCase,
        createTeamRequirementTemplateUseCase: CreateTeamRequirementTemplateUseCase,
        onCreated: @escaping @MainActor (TeamRequirementTemplate) async -> Void
    ) {
        self.courseId = courseId
        self.listCourseCategoriesUseCase = listCourseCategoriesUseCase
        self.createTeamRequirementTemplateUseCase = createTeamRequirementTemplateUseCase
        self.onCreated = onCreated
    }

    var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSubmitting
    }

    func onAppear() async {
        await loadCategories()
    }

    func loadCategories() async {
        guard !isLoadingCategories else { return }

        isLoadingCategories = true
        errorMessage = nil
        defer { isLoadingCategories = false }

        do {
            categories = try await listCourseCategoriesUseCase.execute(courseId: courseId)
        } catch {
            errorMessage = "Не удалось загрузить категории"
        }
    }

    func submit() async {
        guard canSubmit else { return }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let command = CreateTeamRequirementTemplateCommand(
                courseId: courseId,
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                description: normalizedDescription(),
                minTeamSize: try parseOptionalInt(minTeamSize),
                maxTeamSize: try parseOptionalInt(maxTeamSize),
                requiredCategoryId: selectedCategoryId,
                requireAudio: requireAudio,
                requireVideo: requireVideo
            )

            let template = try await createTeamRequirementTemplateUseCase.execute(command)
            await onCreated(template)
        } catch let error as TeamRequirementTemplateValidationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func normalizedDescription() -> String? {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func parseOptionalInt(_ value: String) throws -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        guard let intValue = Int(trimmed) else {
            throw TeamRequirementTemplateValidationError.invalidMinTeamSize
        }

        return intValue
    }
}