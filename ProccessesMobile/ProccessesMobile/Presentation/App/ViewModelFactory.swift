//
//  ViewModelFactory.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Foundation

@MainActor
protocol ViewModelFactory {
    func makeLoginViewModel(authCoordinator: AuthCoordinator) -> LoginViewModel
    func makeRegisterViewModel(authCoordinator: AuthCoordinator) -> RegisterViewModel

    func makeCoursesViewModel(coordinator: CoursesCoordinator) -> CoursesViewModel
    func makeCreateCourseViewModel(coordinator: CoursesCoordinator) -> CreateCourseViewModel
    func makeJoinByCodeViewModel(coordinator: CoursesCoordinator) -> JoinByCodeViewModel

    func makeCourseViewModel(courseId: UUID) -> CourseViewModel
    
    // MARK: - NEW
    func makeCourseCategoriesViewModel(courseId: UUID) -> CourseCategoriesViewModel

    func makeCreateCourseCategoryViewModel(
        courseId: UUID,
        onCreated: @escaping @MainActor () async -> Void
    ) -> CreateCourseCategorySheetViewModel

    func makeEditCourseCategorySheetViewModel(
        courseId: UUID,
        category: CourseCategory,
        onUpdated: @escaping @MainActor () async -> Void
    ) -> EditCourseCategorySheetViewModel
}
