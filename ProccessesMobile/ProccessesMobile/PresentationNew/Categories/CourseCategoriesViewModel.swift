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
    @Published private(set) var selectedCategoryId: UUID?

    private let courseId: UUID
    private let listCourseCategoriesUseCase: ListCourseCategoriesUseCase
    private let deleteCourseCategoryUseCase: DeleteCourseCategoryUseCase
    private let getMyCourseCategoryUseCase: GetMyCourseCategoryUseCase
    private let setMyCourseCategoryUseCase: SetMyCourseCategoryUseCase

    init(
        courseId: UUID,
        listCourseCategoriesUseCase: ListCourseCategoriesUseCase,
        deleteCourseCategoryUseCase: DeleteCourseCategoryUseCase,
        getMyCourseCategoryUseCase: GetMyCourseCategoryUseCase,
        setMyCourseCategoryUseCase: SetMyCourseCategoryUseCase
    ) {
        self.courseId = courseId
        self.listCourseCategoriesUseCase = listCourseCategoriesUseCase
        self.deleteCourseCategoryUseCase = deleteCourseCategoryUseCase
        self.getMyCourseCategoryUseCase = getMyCourseCategoryUseCase
        self.setMyCourseCategoryUseCase = setMyCourseCategoryUseCase
    }

    func load() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            categories = try await listCourseCategoriesUseCase.execute(courseId: courseId)

            async let categoriesTask = listCourseCategoriesUseCase.execute(courseId: courseId)
            async let myCategoryTask = getMyCourseCategoryUseCase.execute(courseId: courseId)

            categories = try await categoriesTask
            let myCategory = try await myCategoryTask
            selectedCategoryId = myCategory?.id

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

    func selectCategory(_ category: CourseCategory) async {
        do {
            try await setMyCourseCategoryUseCase.execute(
                courseId: courseId,
                categoryId: category.id
            )
            selectedCategoryId = category.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearSelection() async {
        do {
            try await setMyCourseCategoryUseCase.execute(
                courseId: courseId,
                categoryId: nil
            )
            selectedCategoryId = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
