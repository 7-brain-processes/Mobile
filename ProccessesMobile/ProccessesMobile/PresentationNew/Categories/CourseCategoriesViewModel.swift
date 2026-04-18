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
    @Published var isCreateSheetPresented = false
    @Published var editingCategory: CourseCategory?
    @Published private(set) var deletingCategoryId: UUID?

    private let courseId: UUID
    private let listCourseCategoriesUseCase: ListCourseCategoriesUseCase
    private let deleteCourseCategoryUseCase: DeleteCourseCategoryUseCase

    init(
        courseId: UUID,
        listCourseCategoriesUseCase: ListCourseCategoriesUseCase,
        deleteCourseCategoryUseCase: DeleteCourseCategoryUseCase
    ) {
        self.courseId = courseId
        self.listCourseCategoriesUseCase = listCourseCategoriesUseCase
        self.deleteCourseCategoryUseCase = deleteCourseCategoryUseCase
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

    func openCreateSheet() {
        isCreateSheetPresented = true
    }

    func closeCreateSheet() {
        isCreateSheetPresented = false
    }

    func openEditSheet(category: CourseCategory) {
        editingCategory = category
    }

    func closeEditSheet() {
        editingCategory = nil
    }

    func handleCategoryCreated() async {
        isCreateSheetPresented = false
        await load()
    }

    func handleCategoryUpdated() async {
        editingCategory = nil
        await load()
    }

    func delete(category: CourseCategory) async {
        deletingCategoryId = category.id
        errorMessage = nil

        do {
            try await deleteCourseCategoryUseCase.execute(
                courseId: courseId,
                categoryId: category.id
            )
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }

        deletingCategoryId = nil
    }
}
